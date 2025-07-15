!/bin/bash

set -e

echo "[+] Обновление системы..."
sudo apt update && sudo apt upgrade -y

echo "[+] Установка X-сервера и драйверов..."
sudo apt install -y xorg xinit xserver-xorg-video-all xserver-xorg-input-all

echo "[+] Установка bspwm и сопутствующих пакетов..."
sudo apt install -y bspwm sxhkd feh picom rofi alacritty polybar git curl unzip wget lightdm lightdm-gtk-greeter fonts-dejavu

echo "[+] Создание структуры конфигураций..."
mkdir -p ~/.config/{bspwm,sxhkd,alacritty,polybar,picom}
mkdir -p ~/Pictures/wallpapers

echo "[+] Копирование конфигов bspwm и sxhkd..."
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc
chmod +x ~/.config/bspwm/bspwmrc

echo "[+] Настройка bspwmrc..."
cat > ~/.config/bspwm/bspwmrc << 'EOF'
!/bin/bash
picom --config ~/.config/picom/picom.conf &
feh --bg-scale ~/Pictures/wallpapers/wall.jpg &
sxhkd &
polybar example &
EOF

echo "[+] Настройка sxhkdrc..."
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
Запуск терминала
super + Return
alacritty

Перезапуск bspwm
super + Escape
bspc wm -r

Закрыть окно
super + q
bspc node -c

Фокус перемещения
super + {h,j,k,l}
bspc node -f {west,south,north,east}
EOF

echo "[+] Настройка polybar..."
cat > ~/.config/polybar/config.ini << 'EOF'
[bar/example]
width = 100%
height = 24
background = #222
foreground = #dfdfdf
modules-left = date
font-0 = sans:size=10

[module/date]
type = internal/date
format = %Y-%m-%d %H:%M:%S
EOF

echo "[+] Настройка picom..."
cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;
shadow = true;
fading = true;
EOF

echo "[+] Настройка alacritty..."
cat > ~/.config/alacritty/alacritty.yml << 'EOF'
font:
normal:
family: monospace
size: 10.0
EOF

echo "[+] Скачивание тестовых обоев..."
wget -O ~/Pictures/wallpapers/wall.jpg https://wallpapercave.com/wp/wp5128415.jpg

echo "[+] Настройка запуска через startx..."
echo 'exec bspwm' > ~/.xinitrc

echo "[+] Включение LightDM..."
sudo systemctl enable lightdm

echo "[+] Готово! Перезагрузите или выполните 'startx' (если без lightdm)."