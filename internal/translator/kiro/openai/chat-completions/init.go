package chat_completions

import (
	. "github.com/router-for-me/CLIProxyAPI/internal/constant"
	"github.com/router-for-me/CLIProxyAPI/internal/interfaces"
	"github.com/router-for-me/CLIProxyAPI/internal/translator/translator"
)

func init() {
	translator.Register(
		OpenAI,
		Kiro,
		ConvertOpenAIRequestToKiro,
		interfaces.TranslateResponse{
			Stream:    ConvertKiroResponseToOpenAI,
			NonStream: ConvertKiroResponseToOpenAINonStream,
		},
	)
}
