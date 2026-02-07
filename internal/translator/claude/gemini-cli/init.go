package geminiCLI

import (
	. "github.com/router-for-me/CLIProxyAPI/internal/constant"
	"github.com/router-for-me/CLIProxyAPI/internal/interfaces"
	"github.com/router-for-me/CLIProxyAPI/internal/translator/translator"
)

func init() {
	translator.Register(
		GeminiCLI,
		Claude,
		ConvertGeminiCLIRequestToClaude,
		interfaces.TranslateResponse{
			Stream:     ConvertClaudeResponseToGeminiCLI,
			NonStream:  ConvertClaudeResponseToGeminiCLINonStream,
			TokenCount: GeminiCLITokenCount,
		},
	)
}
