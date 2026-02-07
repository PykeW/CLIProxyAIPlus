package responses

import (
	. "github.com/router-for-me/CLIProxyAPI/internal/constant"
	"github.com/router-for-me/CLIProxyAPI/internal/interfaces"
	"github.com/router-for-me/CLIProxyAPI/internal/translator/translator"
)

func init() {
	translator.Register(
		OpenaiResponse,
		GeminiCLI,
		ConvertOpenAIResponsesRequestToGeminiCLI,
		interfaces.TranslateResponse{
			Stream:    ConvertGeminiCLIResponseToOpenAIResponses,
			NonStream: ConvertGeminiCLIResponseToOpenAIResponsesNonStream,
		},
	)
}
