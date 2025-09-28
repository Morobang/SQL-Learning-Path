# Installing SQL Databases

This guide will help you install the most popular SQL database systems on your local machine.

## 🎯 Overview

You only need to install ONE database system to get started with SQL. We recommend starting with **MySQL** or **PostgreSQL** for beginners.

## 📊 Database Comparison

| Database | Best For | Difficulty | File Size |
|----------|----------|------------|-----------|
| **MySQL** | Beginners, Web Development | Easy | ~300MB |
| **PostgreSQL** | Advanced Features, Enterprise | Medium | ~400MB |
| **SQL Server** | Windows, Enterprise | Medium | ~1.5GB |

---

## 🐬 Installing MySQL

### Windows
1. **Download MySQL Installer**
   - Go to [MySQL Downloads](https://dev.mysql.com/downloads/installer/)
   - Choose "MySQL Installer 8.0.x for Windows"
   - Select "mysql-installer-web-community" (smaller download)

2. **Installation Steps**
   - Run the installer as Administrator
   - Choose "Developer Default" setup type
   - Click "Execute" to download and install components
   - Set root password (remember this!)
   - Create a user account for development
   - Start MySQL Server as Windows Service

3. **Verify Installation**
   ```bash
   mysql --version
   ```

### macOS
```bash
# Using Homebrew
brew install mysql
brew services start mysql

# Secure installation
mysql_secure_installation
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
```

---

## 🐘 Installing PostgreSQL

### Windows
1. **Download PostgreSQL**
   - Go to [PostgreSQL Downloads](https://www.postgresql.org/download/windows/)
   - Download the installer for your Windows version

2. **Installation Steps**
   - Run installer as Administrator
   - Choose installation directory
   - Select components (PostgreSQL Server, pgAdmin, Command Line Tools)
   - Set password for postgres user
   - Choose port (default: 5432)
   - Select locale

3. **Verify Installation**
   ```bash
   psql --version
   ```

### macOS
```bash
# Using Homebrew
brew install postgresql
brew services start postgresql

# Create database
createdb mydatabase
```

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

---

## 🏢 Installing SQL Server

### Windows
1. **Download SQL Server**
   - Go to [SQL Server Downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
   - Choose "Developer" edition (free)

2. **Installation Steps**
   - Run installer as Administrator
   - Choose "Basic" installation type
   - Accept license terms
   - Choose installation location
   - Wait for installation to complete

3. **Install SQL Server Management Studio (SSMS)**
   - Download from [SSMS Downloads](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
   - Install and launch SSMS
   - Connect to your local SQL Server instance

### Linux (Ubuntu)
```bash
# Import Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Add SQL Server repository
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"

# Install SQL Server
sudo apt-get update
sudo apt-get install -y mssql-server

# Configure SQL Server
sudo /opt/mssql/bin/mssql-conf setup
```

---

## ✅ Post-Installation Checklist

After installing your chosen database:

- [ ] Database service is running
- [ ] You can connect using command line
- [ ] Root/admin password is set and remembered
- [ ] Created a development user account
- [ ] Firewall allows database connections (if needed)
- [ ] Sample database is ready to install

---

## 🚀 Next Steps

1. **Install Database Tools**: [Install_DB_Tools.md](./Install_DB_Tools.md)
2. **Setup Local Database**: [Setup_Local_Database.md](./Setup_Local_Database.md)
3. **Create Sample Databases**: [Create_Sample_Databases.md](./Create_Sample_Databases.md)

---

## 🆘 Troubleshooting

### Common Issues

**Connection Refused**
- Check if database service is running
- Verify port numbers
- Check firewall settings

**Authentication Failed**
- Verify username and password
- Check user permissions
- Reset passwords if needed

**Installation Failed**
- Run installer as Administrator
- Check system requirements
- Disable antivirus temporarily

### Getting Help
- Check official documentation
- Search Stack Overflow
- Join database community forums

---
[← Back to Setup Index](./README.md) | [Next: Install DB Tools →](./Install_DB_Tools.md)
