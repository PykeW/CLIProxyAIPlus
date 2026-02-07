package claude

import (
	. "github.com/PykeW/CLIProxyAIPlus/internal/constant"
	"github.com/PykeW/CLIProxyAIPlus/internal/interfaces"
	"github.com/PykeW/CLIProxyAIPlus/internal/translator/translator"
)

func init() {
	translator.Register(
		Claude,
		Kiro,
		ConvertClaudeRequestToKiro,
		interfaces.TranslateResponse{
			Stream:    ConvertKiroResponseToClaude,
			NonStream: ConvertKiroResponseToClaudeNonStream,
		},
	)
}
