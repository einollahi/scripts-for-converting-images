# 📸 JPG/PNG → AVIF Converter (PowerShell)

A lightweight PowerShell script that converts all **JPG** and **PNG** images inside a folder into the modern, high-efficiency **AVIF** image format using ImageMagick.  
After a successful conversion, the original file is automatically removed.

Perfect for photographers, developers, and anyone wanting **smaller file sizes with better quality**.

---

## 🚀 Features

- Converts **.jpg**, **.jpeg**, and **.png** → **.avif**
- Automatically deletes the original image after a successful conversion
- Supports recursive folder scanning
- Simple defaults — just run the script with no arguments
- Powered by **ImageMagick**

---

## 📦 Requirements

### 1. Install ImageMagick  
Download: https://imagemagick.org  
During installation, enable:

### 2. Allow PowerShell scripts to run (one time only)
```Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned```
