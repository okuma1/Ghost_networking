#!/bin/bash
#Author: Iago Okuma
#Data: 20/12/2022

echo -e "\e[40;36m ===================================================\e[m"
echo -e "\e[40;36m ===================================================\e[m"
echo -e "\e[40;36m ================\e[m""\e[40;36;01mGHOST-NETWORKING\e[m""\e[40;36m===================\e[m"
echo -e "\e[40;36m =================================================== \e[m"
echo -e "\e[40;36m =================================================== \e[m"
echo -e "\e[40;31m===================================================== \e[m"
echo -e "\e[40;31m===================================================== \e[m"

function menu_help()
{
echo -e "MODO DE USO: ""\e[40;36m$0\e[m""\e[40;32m <comando> \e[m""\e""\e[40;33m<HOST/arquivo/URL> \e[m"
echo ""
echo "COMANDOS:"
echo ""
echo -e "\e[40;32m<-p> \e[m""Escanear portas de um host"
echo ""
echo -e "\e[40;32m<-s> \e[m""Escanear Subdominios de um Host"
echo ""
echo -e "\e[40;32m<-a> \e[m""Analisa e infiltra IP Trafego de rede(.pcap)"
echo ""
echo -e "\e[40;32m<-e> \e[m""Enumeracao de Servicos"
echo -e "\e[40;35mRealizar o comando navamente!\e[m"
}

if [ "$1" == "" ]
then
	menu_help
	
elif [ "$1" == "-p" ]
	then
		if [ "$2" == "" ]
		then
			menu_help
		else

			echo -e "\e[40;33;01m[ + ] PORTSCAN\e[m"
			ip="$2"
			echo ""
			echo "HOST: $ip"
			read -p "Deseja fazer scan de uma porta ou de um certo range?(s/n):" resp
				if [ "$resp" == "n" ]
				then
					read -p "Primeira Porta do Range: " port1
					read -p "Ultima Porta do Range: " port2
					echo -e "\e[40;31m====================================================== \e[m"
					echo -e "\e[40;32m[ + ] PORTAS ABERTAS:\e[m"
					echo ""
					for port in $(seq $port1 $port2);
					do
						hping3 -S -p $port -c 1 $ip 2> /dev/null | cut -d  "=" -f6 | cut -d " " -f1 | grep -v "HPING";
					done
				else
					read -p "Porta:" port
					host=$(hping3 -S -p $port -c 1 $ip 2> /dev/null)
						if [ "$?" == "1" ]
						then
							echo -e "\e[40;33;01mPorta\e[m""\e[40;35;01m $port\e[m""\e[40;33;01m Fechada!!\e[m"
						else
							echo -e "\e[40;33;01mHost $ip contem a porta\e[m""\e[40;35;01m $port\e[m""\e[40;33;01m Aberta! \e[m"
						fi
				fi

		fi

elif [ "$1" == "-s" ]
	then
		if [ "$2" == "" ]
		then
			menu_help
		else
			echo -e "\e[40;33;01m[ + ] SCAN-SUBDOMINIOS\e[m"
			echo ""
			wget -O cod_fonte $2
			grep href cod_fonte | cut -d "/" -f3 | grep "\." | cut -d '"' -f1 | grep -v "<l" > lista_subdominio
			echo -e "\e[40;34;01m====================SUBDOMINIOS=======================\e[m"
			for subs in $(cat lista_subdominio);
			do
				echo -e "\e[40;32m$(host $subs | grep "has address")\e[m";
			done
			rm cod_fonte && rm lista_subdominio
		fi
elif [ "$1" == "-a" ]
	then
		if [ "$2" == "" ]
		then
			menu_help
		else
			echo -e "\e[40;33;01m[ + ] AUTO-PACKET\e[m"
			echo ""
			echo "Escolha o que vc quer infiltrar no pacote:"
			echo ""
			echo "[ 1 ] IPs de origem"
			echo "[ 2 ] IPs de destino"
			read -p "> " resp
			echo ""
			if [ "$resp" == "1" ]
			then
				echo -e "\e[40;34;01m========IPs DE ORIGEM E PORTAS REQUISITADAS=========\e[m"
				echo ""
				echo -e "\e[40;32m$(tcpdump -vnr $2 | cut -d " " -f5 | grep -v "ttl" | sort -u)\e[m"
			elif [ "$resp" == "2" ]
			then
				echo -e "\e[40;34;01m========IPs DE DESTINO E PORTAS REQUISITADAS========\e[m"
				echo ""
				echo -e "\e[40;32m$(tcpdump -vnr $2 | cut -d " " -f7 | grep -v "id" | cut -d ":" -f1 | sort -u)\e[m"


			fi	

		fi

elif [ "$1" == "-e" ]
	then
		if [ "$2" == "" ]
		then
			menu_help
		else
			echo -e "\e[40;33;01m[ + ] SERVICOS\e[m"
			echo ""
			echo "Escolha o servico que queira enumerar!"
			echo ""
			echo "[ 21 ] FTP"
			echo ""
			echo "[ 80 ] WEB "
			echo ""
			read -p "> " resp
			echo ""
			if [ "$resp" == "21" ]
			then
				ftp $2	
			elif [ "$resp" == "80" ]
			then
				whatweb $2
				i="s"
				while [ "$i" == "s" ]
				do
					echo ""
					echo "Alem da enumeracao, temos essas funcionalidades para o seu pentest: "
					echo ""
					echo "[ 0 ] Finalizar sessao"
					echo ""
					echo "[ 1 ] BruteForce nos diretorios"
					echo ""
					echo "[ 2 ] Reverse Shell"
					echo ""
					echo "[ 3 ] SQL Injection"
					echo ""
					read -p "> " oi
					if [ "$oi" == "0" ]
					then
						break
					elif [ "$oi" == "1" ]
					then
						dirsearch -u $2
					elif [ "$oi" == "2" ]
					then
						echo "Em breve....."
					fi

					read -p "Deseja realizar outra funcao?(s/n)?:  " i
				
				done
			fi

		fi
fi
