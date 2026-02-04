function '??'
    if not set -q OPENAI_API_KEY
        echo "Please set your OPENAI_API_KEY environment variable."
        return 1
    end

    set prompt (string join " " $argv)

    set sys_prompt "You are GPT-5.2-Pro: a concise expert assistant. Answer in 1–5 clear, helpful sentences with relevant context."

    set payload (jq -nc \
        --arg model "gpt-4-1106-preview" \
        --arg system "$sys_prompt" \
        --arg user "$prompt" \
        '{model: $model, messages: [
            {role: "system", content: $system},
            {role: "user", content: $user}
        ], temperature: 0.5}')

    curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$payload" \
    | jq -r '.choices[0].message.content // "⚠️ No response from ChatGPT."'
end

