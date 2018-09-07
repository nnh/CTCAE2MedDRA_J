# CTCAEのLLTCDとMedDRA/JのLLTCDの対応表を作成する
# readxlのインストールが必要
# install.packages('readxl')
# *** set path ***
prtpath <- "/Volumes/Projects/NMC ISR 情報システム研究室/MedDRA/V22.1"

library("readxl")
# *** constant ***
# output csv name
kOutputCSV <- "output.csv"
# input csv column name
kOutputColumn <- c("TERM日本語", "CTCAE_LLT", "MedDRA_LLT")
# input csv name
kMedDRACSV <- "llt_j.asc"
# input csv column name
kColCode <- "llt_code"
kColKanji <- "llt_s_kanji"
kColJcurr <- "llt_s_jcurr"

# ASCIIフォルダと同階層にCTCAEフォルダを作成し、ダウンロードしたEXCELを入れてください
ctcaepath <- paste0(prtpath, "/CTCAE")
rawdatapath <- paste0(prtpath, "/ASCII")
# 出力フォルダが存在しなければ作成
outputpath <- paste0(prtpath, "/output")
if (!(file.exists(outputpath))){
  dir.create(outputpath)
}

# ctcaeファイル名をフルパスで取得
file_list <- list.files(ctcaepath, full.names=T)
# 複数ファイルが入っていたら処理終了
if (length(file_list) == 1) {
  df <- read_excel(file_list[1], sheet=1, col_names=T)
  # 必要なレコード、列のみ抽出　コードと漢字病名のみ
  df <- df[c(2, 6)]
  names(df) <- c(kColCode, kColKanji)
  ctcae_df <- subset(df, !is.na(df[ ,kColKanji]))
  # MedDRA/Jファイルを探す
  meddrapath <- rawdatapath
  count_temp <- 0
  repeat {
    # 対象ファイルが存在しない場合のループ防止
    if (count_temp > 2) {
      break
    }
    # フルパスでなく、名前のみ取得
    file_list <- list.files(meddrapath, full.names=F)
    # トップの1ファイルを確認し、名前が*.ascでなければフォルダとみなす
    grep_temp <- grep("\\.asc$", file_list[1])
    if (length(grep_temp) > 0) {
      # 読み込み対象ファイル
      if (grep(kMedDRACSV, file_list) > 0) {
        llt_jpath <- paste0(meddrapath, "/", kMedDRACSV)
        df2 <- read.csv(llt_jpath, as.is=T, sep="$", header=F, fileEncoding="cp932")
        # 必要なレコード、列のみ抽出 3列目がYのものだけ
        df2 <- df2[c(1, 2, 3)]
        names(df2) <- c(kColCode, kColKanji, kColJcurr)
        meddra_df <- subset(df2, df2[ ,kColJcurr] == "Y")
        # MedDRAとCTCAEを漢字名完全一致でマージ
        merge_df <- merge(ctcae_df, meddra_df, by="llt_s_kanji")
        output_csv <- merge_df[c(1, 2, 3)]
        names(output_csv) <- kOutputColumn
        write.csv(output_csv, paste(outputpath, kOutputCSV, sep="/"), na='""', row.names=F)
      }
      # ループ抜ける
      break
    } else {
      # フォルダ
      meddrapath <- paste(meddrapath, file_list[1], sep="/")
      count_temp <- count_temp + 1
    }
  }
} else {
  warning("CTCAEファイルは一つだけ格納してください")
}

