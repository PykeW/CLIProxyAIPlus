package claude

import (
	. "github.com/PykeW/CLIProxyAIPlus/internal/constant"
	"github.com/PykeW/CLIProxyAIPlus/internal/interfaces"
	"github.com/PykeW/CLIProxyAIPlus/internal/translator/translator"
)

func init() {
	translator.Register(
		Claude,
		Antigravity,
		ConvertClaudeRequestToAntigravity,
		interfaces.TranslateResponse{
			Stream:     ConvertAntigravityResponseToClaude,
			NonStream:  ConvertAntigravityResponseToClaudeNonStream,
			TokenCount: ClaudeTokenCount,
		},
	)
}
