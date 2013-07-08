CC_PORT = "8181"

execute "add cloud controller redirect" do
        command "iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport #{CC_PORT} -j DNAT --to #{node['ipaddress']}:#{CC_PORT}"
end
