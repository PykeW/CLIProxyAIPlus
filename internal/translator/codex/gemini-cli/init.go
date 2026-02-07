package geminiCLI

import (
	. "github.com/router-for-me/CLIProxyAPI/internal/constant"
	"github.com/router-for-me/CLIProxyAPI/internal/interfaces"
	"github.com/router-for-me/CLIProxyAPI/internal/translator/translator"
)

func init() {
	translator.Register(
		GeminiCLI,
		Codex,
		ConvertGeminiCLIRequestToCodex,
		interfaces.TranslateResponse{
			Stream:     ConvertCodexResponseToGeminiCLI,
			NonStream:  ConvertCodexResponseToGeminiCLINonStream,
			TokenCount: GeminiCLITokenCount,
		},
	)
}
