#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  exit 1
fi

groupadd default_users
useradd -m -s /bin/bash -g default_users user

groupadd secret_users
useradd -m -s /bin/bash -g secret_users secret_agent
useradd -m -s /bin/bash -g secret_users secret_spy
useradd -m -s /bin/bash -g secret_users secret_boss

for usr in secret_agent secret_spy secret_boss; do
  chown -R "$usr:secret_users" "/home/$usr"
  chmod -R 770 "/home/$usr"
  chmod g+s "/home/$usr"
done

chmod 777 /var

apt update -y
apt install -y apache2

systemctl is-active --quiet apache2 && echo "Apache2 активен" || echo "Apache2 НЕ активен"

echo "%default_users ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/default_users_nopasswd
chmod 440 /etc/sudoers.d/default_users_nopasswd
