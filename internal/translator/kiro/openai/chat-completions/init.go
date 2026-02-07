package chat_completions

import (
	. "github.com/PykeW/CLIProxyAIPlus/internal/constant"
	"github.com/PykeW/CLIProxyAIPlus/internal/interfaces"
	"github.com/PykeW/CLIProxyAIPlus/internal/translator/translator"
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
