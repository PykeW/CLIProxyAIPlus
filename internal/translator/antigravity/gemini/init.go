package gemini

import (
	. "github.com/PykeW/CLIProxyAIPlus/internal/constant"
	"github.com/PykeW/CLIProxyAIPlus/internal/interfaces"
	"github.com/PykeW/CLIProxyAIPlus/internal/translator/translator"
)

func init() {
	translator.Register(
		Gemini,
		Antigravity,
		ConvertGeminiRequestToAntigravity,
		interfaces.TranslateResponse{
			Stream:     ConvertAntigravityResponseToGemini,
			NonStream:  ConvertAntigravityResponseToGeminiNonStream,
			TokenCount: GeminiTokenCount,
		},
	)
}
