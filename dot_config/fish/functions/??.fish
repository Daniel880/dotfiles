function '??'
    if not set -q OPENAI_API_KEY
        echo "Please set your OPENAI_API_KEY environment variable."
        return 1
    end

    set prompt (string join " " $argv)

    set payload (jq -nc \
        --arg model "gpt-4.1-mini" \
        --arg sys "You are a concise expert assistant. Answer in 1–5 clear, helpful sentences with relevant context." \
        --arg user "$prompt" \
        '{
          model: $model,
          input: [
            {role:"system", content:[{type:"input_text", text:$sys}]},
            {role:"user",   content:[{type:"input_text", text:$user}]}
          ],
          temperature: 0.5
        }')

    curl -fsS https://api.openai.com/v1/responses \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$payload" \
    | jq -r '
        if .error then
          "⚠️ " + (.error.message // "Unknown API error")
        else
          (.output[0].content[0].text // "⚠️ No text in response.")
        end
      '
end

