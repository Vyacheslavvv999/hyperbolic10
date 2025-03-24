#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

# Отображаем логотип
curl -s https://raw.githubusercontent.com/noxuspace/cryptofortochka/main/logo_club.sh | bash

# Меню
echo -e "${YELLOW}Выберите действие:${NC}"
echo -e "${CYAN}1) Установка бота${NC}"
echo -e "${CYAN}2) Обновление бота${NC}"
echo -e "${CYAN}3) Просмотр логов${NC}"
echo -e "${CYAN}4) Рестарт бота${NC}"
echo -e "${CYAN}5) Удаление бота${NC}"

echo -e "${YELLOW}Введите номер:${NC} "
read choice

case $choice in
    1)
        echo -e "${BLUE}Установка бота...${NC}"

        # --- 1. Обновление системы и установка необходимых пакетов ---
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y python3 python3-venv python3-pip curl
        
        # --- 2. Создание папки проекта ---
        PROJECT_DIR="$HOME/hyperbolic"
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR" || exit 1
        
        # --- 3. Создание виртуального окружения и установка зависимостей ---
        python3 -m venv venv
        source venv/bin/activate
        pip install --upgrade pip
        pip install requests
        deactivate
        cd
        
        # --- 4. Запрос 10 API-ключей ---
        echo -e "${YELLOW}Введите ваши API-ключи для Hyperbolic (по одному на строку):${NC}"
        echo -e "${CYAN}Ключ 1:${NC}"
        read API_KEY1
        echo -e "${CYAN}Ключ 2:${NC}"
        read API_KEY2
        echo -e "${CYAN}Ключ 3:${NC}"
        read API_KEY3
        echo -e "${CYAN}Ключ 4:${NC}"
        read API_KEY4
        echo -e "${CYAN}Ключ 5:${NC}"
        read API_KEY5
        echo -e "${CYAN}Ключ 6:${NC}"
        read API_KEY6
        echo -e "${CYAN}Ключ 7:${NC}"
        read API_KEY7
        echo -e "${CYAN}Ключ 8:${NC}"
        read API_KEY8
        echo -e "${CYAN}Ключ 9:${NC}"
        read API_KEY9
        echo -e "${CYAN}Ключ 10:${NC}"
        read API_KEY10

        # --- 5. Создание hyper_bot.py с 10 ключами ---
        cat <<EOT > "$PROJECT_DIR/hyper_bot.py"
import time
import requests
import logging
import random

# Конфигурация 10 API-ключей Hyperbolic
API_CONFIGS = [
    {"name": "Hyperbolic_Account1", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY1", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account2", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY2", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account3", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY3", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account4", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY4", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account5", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY5", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account6", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY6", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account7", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY7", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account8", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY8", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account9", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY9", "model": "meta-llama/Llama-3.3-70B-Instruct"},
    {"name": "Hyperbolic_Account10", "url": "https://api.hyperbolic.xyz/v1/chat/completions", "key": "$API_KEY10", "model": "meta-llama/Llama-3.3-70B-Instruct"}
]

MAX_TOKENS = 2048
TEMPERATURE = 0.7
TOP_P = 0.9
DELAY_BETWEEN_QUESTIONS = 45

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_response(question: str, api_config: dict) -> str:
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_config['key']}"
    }
    data = {
        "messages": [{"role": "user", "content": question}],
        "model": api_config["model"],
        "max_tokens": MAX_TOKENS,
        "temperature": TEMPERATURE,
        "top_p": TOP_P
    }
    try:
        response = requests.post(api_config["url"], headers=headers, json=data, timeout=30)
        response.raise_for_status()
        json_response = response.json()
        return json_response.get("choices", [{}])[0].get("message", {}).get("content", "No answer")
    except Exception as e:
        logger.error(f"Ошибка API {api_config['name']} для вопроса '{question}': {e}")
        return "Error"

def main():
    try:
        with open("questions.txt", "r", encoding="utf-8") as f:
            questions = [line.strip() for line in f if line.strip()]
    except Exception as e:
        logger.error(f"Ошибка чтения файла questions.txt: {e}")
        return

    if not questions:
        logger.error("В файле questions.txt нет вопросов.")
        return

    index = 0
    while True:
        question = questions[index]
        api_config = random.choice(API_CONFIGS)
        logger.info(f"Вопрос #{index+1} отправлен в {api_config['name']}: {question}")
        try:
            answer = get_response(question, api_config)
            logger.info(f"Ответ: {answer}")
        except Exception as e:
            logger.error(f"Ошибка при получении ответа: {e}")
        index = (index + 1) % len(questions)
        time.sleep(DELAY_BETWEEN_QUESTIONS)

if __name__ == "__main__":
    main()
EOT

        # --- 6. Скачивание файла questions.txt ---
        QUESTIONS_URL="https://raw.githubusercontent.com/Vyacheslavvv999/multihyper/main/questions.txt"
        curl -fsSL -o hyperbolic/questions.txt "$QUESTIONS_URL"

        # --- 7. Создание systemd сервиса ---
        USERNAME=$(whoami)
        HOME_DIR=$(eval echo ~$USERNAME)

        sudo bash -c "cat <<EOT > /etc/systemd/system/hyper-bot.service
[Unit]
Description=Hyperbolic API Bot Service
After=network.target

[Service]
User=$USERNAME
WorkingDirectory=$HOME_DIR/hyperbolic
ExecStart=$HOME_DIR/hyperbolic/venv/bin/python $HOME_DIR/hyperbolic/hyper_bot.py
Restart=always
Environment=PATH=$HOME_DIR/hyperbolic/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

[Install]
WantedBy=multi-user.target
EOT"

        # --- 8. Обновление конфигурации systemd и запуск сервиса ---
        sudo systemctl daemon-reload
        sudo systemctl restart systemd-journald
        sudo systemctl enable hyper-bot.service
        sudo systemctl start hyper-bot.service
        
        # Заключительное сообщение
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${YELLOW}Команда для проверки логов:${NC}"
        echo "sudo journalctl -u hyper-bot.service -f"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        sleep 2
        sudo journalctl -u hyper-bot.service -f
        ;;

    2)
        echo -e "${BLUE}Обновление бота...${NC}"
        sleep 2
        echo -e "${GREEN}Обновление бота не требуется!${NC}"
        ;;

    3)
        echo -e "${BLUE}Просмотр логов...${NC}"
        sudo journalctl -u hyper-bot.service -f
        ;;

    4)
        echo -e "${BLUE}Рестарт бота...${NC}"
        sudo systemctl restart hyper-bot.service
        sudo journalctl -u hyper-bot.service -f
        ;;
        
    5)
        echo -e "${BLUE}Удаление бота...${NC}"
        sudo systemctl stop hyper-bot.service
        sudo systemctl disable hyper-bot.service
        sudo rm /etc/systemd/system/hyper-bot.service
        sudo systemctl daemon-reload
        sleep 2
        rm -rf $HOME_DIR/hyperbolic
        echo -e "${GREEN}Бот успешно удален!${NC}"
        echo -e "${PURPLE}-----------------------------------------------------------------------${NC}"
        echo -e "${GREEN}CRYPTO FORTOCHKA — вся крипта в одном месте!${NC}"
        echo -e "${CYAN}Наш Telegram https://t.me/cryptoforto${NC}"
        sleep 1
        ;;

    *)
        echo -e "${RED}Неверный выбор. Пожалуйста, введите номер от 1 до 5!${NC}"
        ;;
esac