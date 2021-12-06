#/bin/bash

salt=$(openssl rand -hex 4)
password=$1

hashed=$(echo -n "${password}${salt}" | sha1sum | awk '{print $1}')

echo "Password: $password"
echo "Hashed password + salt: {${hashed}${salt}"
