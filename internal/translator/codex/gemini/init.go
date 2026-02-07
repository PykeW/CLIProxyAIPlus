package gemini

import (
	. "github.com/PykeW/CLIProxyAIPlus/internal/constant"
	"github.com/PykeW/CLIProxyAIPlus/internal/interfaces"
	"github.com/PykeW/CLIProxyAIPlus/internal/translator/translator"
)

func init() {
	translator.Register(
		Gemini,
		Codex,
		ConvertGeminiRequestToCodex,
		interfaces.TranslateResponse{
			Stream:     ConvertCodexResponseToGemini,
			NonStream:  ConvertCodexResponseToGeminiNonStream,
			TokenCount: GeminiTokenCount,
		},
	)
}
