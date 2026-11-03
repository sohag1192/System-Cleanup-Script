<div align="center">

# 🧹 সিস্টেম ক্লিনআপ ও ডিস্ক স্পেস অপ্টিমাইজেশন স্ক্রিপ্ট

**লিনাক্স (Ubuntu/Debian) ও Proxmox সার্ভারের অটোমেটিক ডিস্ক ক্লিনআপ এবং লগ অপ্টিমাইজেশন টুলস।**

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FSystem-Cleanup-Script&count_bg=%2322c55e&title_bg=%231f2937&icon=&icon_color=%23ffffff&title=Total%20%7C%20Today%20Views&edge_flat=false)](https://hits.seeyoufarm.com)
[![GitHub Stars](https://img.shields.io/github/stars/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=gold)](https://github.com/sohag1192/System-Cleanup-Script/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=blue)](https://github.com/sohag1192/System-Cleanup-Script/network/members)
[![License](https://img.shields.io/github/license/sohag1192/System-Cleanup-Script?style=for-the-badge&color=green)](LICENSE)
[![Repo Size](https://img.shields.io/github/repo-size/sohag1192/System-Cleanup-Script?style=for-the-badge&color=orange)](https://github.com/sohag1192/System-Cleanup-Script)
[![Last Commit](https://img.shields.io/github/last-commit/sohag1192/System-Cleanup-Script?style=for-the-badge&color=purple)](https://github.com/sohag1192/System-Cleanup-Script/commits/main)

<br/>

<p align="center">
  <a href="README.md"><b>English</b></a> •
  <a href="README.bn.md"><b>বাংলা (Bengali)</b></a>
</p>

</div>

---

## 📖 সারসংক্ষেপ (Overview)

দীর্ঘদিন চলার কারণে লিনাক্স এবং Proxmox সার্ভারে প্রচুর পরিমাণে ডিস্ক স্পেস দখল হয়ে যায়—যেমন: `systemd` জার্নাল লগ, পুরনো রোটেটেড লগ (`.gz`, `.1`), APT প্যাকেজ আর্কাইভ ক্যাশ এবং রিসাইকেল ট্র্যাশ। এর ফলে সার্ভারের রুট পার্টিশন ফুল হয়ে ডাটাবেস ক্র্যাশ বা সার্ভিস বন্ধ হয়ে যেতে পারে।

এই রিপোজিটরিতে **Ubuntu / Debian** এবং **Proxmox VE** সার্ভারের জন্য আলাদা ফোল্ডারে সম্পূর্ণ টেস্টেড শেল স্ক্রিপ্ট সাজানো হয়েছে। প্রতিটি স্ক্রিপ্টে লগ ফাইল ডিলিট না করে নিরাপদে **ট্রাঙ্কেট (`truncate -s 0`)** করা হয়েছে, যাতে রানিং সার্ভিস কখনো ক্র্যাশ না করে।

---

## 🏆 কোন স্ক্রিপ্টটি সবচেয়ে সেরা? (Recommended)

| সার্ভারের ধরন | সেরা স্ক্রিপ্ট | কেন এটি সবচেয়ে সেরা? |
| :--- | :--- | :--- |
| **Ubuntu / Debian** | [`ubuntu/log_cleanup.sh`](ubuntu/log_cleanup.sh) | 🌟 **সবচেয়ে নিরাপদ ও ভারসাম্যপূর্ণ:** সিস্টেম জার্নাল লগ পরিষ্কার করে (`journalctl --vacuum-time=7d`), লগইন হিস্ট্রি (`wtmp`/`btmp`) অক্ষত রাখে, কোনো জরুরি প্যাকেজ ডিলিট করে না এবং ডিস্ক ব্যবহারের ফাইনাল রিপোর্ট দেখায়। |
| **Proxmox VE** | [`proxmox/proxmox-cleanup.sh`](proxmox/proxmox-cleanup.sh) | 🌟 **১০০% স্টোরেজ সুরক্ষিত:** জার্নাল ও সার্ভিস লগ এবং APT ক্যাশ ক্লিন করে, কিন্তু **Backups (`/var/lib/vz/dump/`)**, **ISO Images (`/var/lib/vz/template/iso/`)** এবং **CT Templates (`/var/lib/vz/template/cache/`)**-এর কোনো ফাইলে হাত দেয় না। |

---

## 📁 রিপোজিটরি ফোল্ডার স্ট্রাকচার (Repository Structure)

```plaintext
System-Cleanup-Script/
├── ubuntu/                      # Ubuntu ও Debian সার্ভার ক্লিনআপ স্ক্রিপ্ট
│   ├── log_cleanup.sh           # ⭐ [BEST] জার্নাল ও ডিস্ক রিপোর্টসহ সেরা Ubuntu ক্লিনার
│   ├── cleaning.sh              # মাল্টি-সার্ভিস ক্লিনার (Nginx, Apache, MySQL, Flussonic)
│   ├── clean_logs.sh            # সাধারণ লগ ও APT ক্যাশ ক্লিনার
│   ├── clean-logs.sh            # POSIX sh ক্যাশ ও লগ স্ক্রিপ্ট
│   └── clean_up.sh              # Nginx RTMP সাপোর্টসহ জেনারেল স্ক্রিপ্ট
├── proxmox/                     # Proxmox VE ক্লিনআপ স্ক্রিপ্ট
│   ├── proxmox-cleanup.sh       # ⭐ [BEST] স্টোরেজ সুরক্ষিত Proxmox লগ ও ক্যাশ ক্লিনার
│   └── proxmox_clean.sh         # লাইটওয়েট Proxmox স্ক্রিপ্ট
├── upload.bat                   # উইন্ডোজ গিট অটো-কমিট ও পুশ স্ক্রিপ্ট
├── .gitattributes               # শেল স্ক্রিপ্টের জন্য Unix LF লাইন এন্ডিং নিশ্চিত করে
├── LICENSE                      # MIT লাইসেন্স
├── README.md                    # ইংরেজি ডকুমেন্টেশন
└── README.bn.md                 # বাংলা ডকুমেন্টেশন
```

---

## ⚡ দ্রুত ইনস্টলেশন ও সরাসরি রান (Quick Usage)

### ১. Ubuntu / Debian সার্ভারের জন্য (প্রস্তাবিত: `log_cleanup.sh`)

**এক লাইনে সরাসরি রান করুন:**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh | sudo bash
```

**অথবা ডাউনলোড করে রান করুন:**
```bash
wget -O log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh
chmod +x log_cleanup.sh
sudo ./log_cleanup.sh
```

---

### ২. Proxmox VE সার্ভারের জন্য (প্রস্তাবিত: `proxmox-cleanup.sh`)

**এক লাইনে সরাসরি রান করুন:**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh | sudo bash
```

**অথবা ডাউনলোড করে রান করুন:**
```bash
wget -O proxmox-cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh
chmod +x proxmox-cleanup.sh
sudo ./proxmox-cleanup.sh
```

> [!IMPORTANT]
> **Proxmox স্টোরেজ সুরক্ষা:** `proxmox/proxmox-cleanup.sh` স্ক্রিপ্টটি আপনার রাখা **Backups**, **ISO Images** এবং **Container (CT) Templates** এর একটি ফাইলও ডিলিট করবে না। শুধুমাত্র অপ্রয়োজনীয় লগ ও ক্যাশ মুছে ডিস্ক খালি করা হয়।

---

## 📊 বিস্তারিত ফিচার তুলনা (Feature Matrix)

| ফিচার | `ubuntu/log_cleanup.sh` ⭐ | `ubuntu/cleaning.sh` | `ubuntu/clean_logs.sh` | `proxmox/proxmox-cleanup.sh` ⭐ |
| :--- | :---: | :---: | :---: | :---: |
| **সিস্টেম লগ ট্রাঙ্কেট** | ✅ (`truncate -s 0`) | ✅ (`truncate -s 0`) | ✅ (`: >`) | ✅ (`truncate -s 0`) |
| **Systemd Journal Vacuum** | ✅ (`--vacuum-time=7d`) | ❌ | ❌ | ✅ (`--vacuum-time=7d`) |
| **`wtmp` / `btmp` লগইন ফাইল রক্ষা** | ✅ (সুরক্ষিত) | ❌ | ❌ | ✅ (সুরক্ষিত) |
| **পুরনো রোটেটেড লগ (`.gz`, `.[0-9]`)** | ✅ ডিলিট হয় | ✅ ডিলিট হয় | ✅ ডিলিট হয় | ✅ ডিলিট হয় |
| **APT ক্যাশ ও Autoclean** | ✅ | ✅ | ✅ | ✅ |
| **অরফান প্যাকেজ রিমুভ (`deborphan`)** | ✅ নিরাপদ | ✅ | ✅ | ✅ নিরাপদ |
| **রিসাইকেল ট্র্যাশ ক্লিন** | ✅ | ✅ | ✅ | ✅ |
| **Nginx / ওয়েব সার্ভার লগ** | ✅ | ✅ (Apache, MySQL, Flussonic) | ✅ | ✅ |
| **Backups ও ISO Images অক্ষত রাখা** | N/A | N/A | N/A | ✅ **১০০% সুরক্ষিত** |
| **ডিস্ক রেজাল্ট রিপোর্ট (`df -h`)** | ✅ | ❌ | ❌ | ❌ |

---

## ⏰ ক্রন জব দিয়ে অটোমেশন (Scheduled Cleanup)

সার্ভার নিজে থেকেই নির্দিষ্ট সময় পর পর ক্লিন করতে রুট ক্রন জবে শিডিউল সেট করুন:

১. ক্রনট্যাব এডিট করুন:
   ```bash
   sudo crontab -e
   ```

২. যেকোনো একটি শিডিউল যোগ করুন (আপনার প্রয়োজন অনুযায়ী স্ক্রিপ্ট পাথ দিন):

   * **প্রতিদিন রাত ৩:০০ টায় (হাই-ট্রাফিক সার্ভারের জন্য উপযুক্ত):**
     ```cron
     0 3 * * * /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

   * **প্রতি সপ্তাহে রবিবার রাত ২:০০ টায়:**
     ```cron
     0 2 * * 0 /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

   * **প্রতি মাসের ১ তারিখ ভোর ৪:০০ টায়:**
     ```cron
     0 4 1 * * /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

৩. ক্রন সার্ভিস রানিং আছে কিনা নিশ্চিত করুন:
   ```bash
   sudo systemctl enable --now cron
   ```

---

## 🔧 ট্রাবলশুটিং (`$'\r': command not found` সমাধান)

উইন্ডোজ মেশিনে কাজ করার পর লিনাক্সে স্ক্রিপ্ট চালালে যদি এই এরর আসে:
```plaintext
syntax error near unexpected token $'\r'
cleaning.sh: line 9: $'\r': command not found
```
এর কারণ হলো উইন্ডোজের CRLF (`\r\n`) লাইন এন্ডিং। এটি এক কমান্ডে সমাধান করতে পারেন:

```bash
# পদ্ধতি ১: dos2unix ব্যবহার করে
sudo apt-get install -y dos2unix
dos2unix *.sh

# পদ্ধতি ২: sed ব্যবহার করে (কোনো প্যাকেজ ছাড়া)
sed -i 's/\r$//' *.sh
```

---

## 📈 স্টার হিস্ট্রি (Star History)

[![Star History Chart](https://api.star-history.com/svg?repos=sohag1192/System-Cleanup-Script&type=Date)](https://star-history.com/#sohag1192/System-Cleanup-Script&Date)

---

## 👤 লেখক ও মেইনটেইনার (Maintainer)

**মো: সোহাগ রানা (Md. Sohag Rana)**  
নেটওয়ার্ক ও আইটি ইনফ্রাস্ট্রাকচার স্পেশালিস্ট  
* **GitHub:** [@sohag1192](https://github.com/sohag1192)  
* **ইমেইল:** [sohag1192@gmail.com](mailto:sohag1192@gmail.com)  
* **টেলিগ্রাম:** [@sohag1192](https://t.me/sohag1192)

---

## 📄 লাইসেন্স (License)

এই প্রজেক্টটি [MIT লাইসেন্স](LICENSE)-এর অধীনে উন্মুক্ত।
