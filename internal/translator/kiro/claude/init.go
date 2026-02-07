package claude

import (
	. "github.com/router-for-me/CLIProxyAPI/internal/constant"
	"github.com/router-for-me/CLIProxyAPI/internal/interfaces"
	"github.com/router-for-me/CLIProxyAPI/internal/translator/translator"
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
