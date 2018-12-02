library(shiny)
library(rintrojs) # パッケージを読み込む

# アプリケーションのUIを定義
ui <- fluidPage(
  
  introjsUI(), # これをUI定義のどこかに含める
  
  # アプリケーションのタイトル
  titlePanel("rintrojsで手軽にチュートリアルを実装"),
  
  # サイドバー
  sidebarLayout(
    sidebarPanel(
      introBox( # チュートリアルのステップ
        sliderInput("bins", "ビンの数:", min = 1, max = 50, value = 30), # ハイライトされる要素
        data.step = 1, # ステップ番号
        data.intro = "このスライダーを動かしてビンの数を変更してください" # このステップのメッセージ
      ),
      
      actionButton("tutorial", "チュートリアルを開始")
    ),
    
    # メインパネル
    mainPanel(
      introBox( # チュートリアルのステップ
        plotOutput("distPlot"),
        data.step = 2, # ステップ番号
        data.intro = "スライダーの値に合わせてこのヒストグラムが変化します" # このステップのメッセージ
      )
    )
  )
)

# サーバー側ロジックを定義
server <- function(input, output, session) {
  
  output$distPlot <- renderPlot({
    # ui.Rから来た input$bins に基づいてビンを生成
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # 指定のビン数でヒストグラムを描画
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  observeEvent(
    input$tutorial, # tutorialボタンがクリックされたら
    introjs( # チュートリアルを開始する
      session,
      options = list( # オプション設定
        nextLabel = "次へ", # 次のステップへ進むボタンのラベル
        prevLabel = "戻る", # 前のステップへ戻るボタンのラベル
        skipLabel = "やめる", # チュートリアルをスキップするボタンのラベル
        doneLabel = "完了", # チュートリアルを完了するボタンのラベル
        showBullets = FALSE, # 進捗を表す中点マークを表示する/しない
        showProgress = TRUE # プログレスバーを表示する/しない
      )
    )
  )
}

# アプリケーションを起動する
shinyApp(ui = ui, server = server)
