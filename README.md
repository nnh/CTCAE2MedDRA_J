CTCAE2MedDRA_J
======
CTCAEのLLTCDとMedDRA/JのLLTCDの対応表を作成します。  
実行前にreadxlパッケージをインストールしてください。  

- 実行方法  
プログラムソース内5行目の'prtpath'に、MedDRA/Jのデータが入っているフォルダを設定してください。  
MedDRA/Jのフォルダの、「ASCII」フォルダと同階層に「CTCAE」フォルダを作成してください。  
![Readme_pic](https://github.com/nnh/CTCAE2MedDRA_J/wiki/Readme_image/readme_1_1.png)  
「CTCAE」フォルダに、http://www.jcog.jp/doctor/tool/ctcaev4.html からダウンロードしたCTCAEのEXCELファイルを格納し、プログラムを実行してください。  
![Readme_pic](https://github.com/nnh/CTCAE2MedDRA_J/wiki/Readme_image/readme_2_1.PNG)  
「ASCII」フォルダと同階層に「output」フォルダが作成され、対応表が「output.csv」という名前で出力されます。
