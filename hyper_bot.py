import time
import requests
import logging
import random

# Конфигурация 10 API-ключей Hyperbolic
API_CONFIGS = [
    {
        "name": "Hyperbolic_Account1",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "eyJhbGciOiJIUzI1NiIsInR5cCiwiaWF0IjoxNzQyNzQ1ODA4fQ.DooEfKGDmiBGrdVQcHbN8Dk2SkaUo2gJASeuO2xgIzE",  # Первый ключ
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account2",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ВТОРОЙ_API_КЛЮЧ",  # Замени на второй ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account3",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ТРЕТИЙ_API_КЛЮЧ",  # Замени на третий ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account4",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ЧЕТВЁРТЫЙ_API_КЛЮЧ",  # Замени на четвёртый ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account5",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ПЯТЫЙ_API_КЛЮЧ",  # Замени на пятый ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account6",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ШЕСТОЙ_API_КЛЮЧ",  # Замени на шестой ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account7",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "СЕДЬМОЙ_API_КЛЮЧ",  # Замени на седьмой ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account8",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ВОСЬМОЙ_API_КЛЮЧ",  # Замени на восьмой ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account9",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ДЕВЯТЫЙ_API_КЛЮЧ",  # Замени на девятый ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    },
    {
        "name": "Hyperbolic_Account10",
        "url": "https://api.hyperbolic.xyz/v1/chat/completions",
        "key": "ДЕСЯТЫЙ_API_КЛЮЧ",  # Замени на десятый ключ Hyperbolic
        "model": "meta-llama/Llama-3.3-70B-Instruct",
    }
]

MAX_TOKENS = 2048
TEMPERATURE = 0.7
TOP_P = 0.9
DELAY_BETWEEN_QUESTIONS = 45  # задержка между вопросами в секундах

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
    # Чтение вопросов из файла "questions.txt"
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
        # Случайный выбор API для каждого вопроса
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