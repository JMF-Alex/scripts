#  Some util scripts
### Index
- [SSH](#ssh)
- - [my_public_key.sh](#my_public_key.sh)
  - [fail2ban.sh](#Fail2ban)

# SSH
## [my_public_key.sh](https://github.com/JMF-Alex/scripts/blob/main/ssh/my_public_key.sh)
This is a simple script to add my public key to the authorized_keys file

Execute it with:
```bash
curl -fsSL https://raw.githubusercontent.com/JMF-Alex/scripts/refs/heads/main/ssh/my_public_key.sh | bash
```

## [Fail2ban](https://github.com/JMF-Alex/scripts/blob/main/ssh/fail2ban.sh)
This is a script to configure fast fail2ban with abuseipdb api 

Execute it with:
```bash
curl -fsSL https://raw.githubusercontent.com/JMF-Alex/scripts/refs/heads/main/ssh/fail2ban.sh | bash
```
