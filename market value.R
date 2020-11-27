market <- mydsws$timeSeriesListRequest(instrument = c( "@AMZN", "U:ABT", "U:AES", "@ABMD", "U:IBM", "@AMD","@ADBE", "U:ARE", "U:APD", "U:ALK", "U:BXP", "U:ALL","U:HON", "@AMGN"),
                                     datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market2 <- mydsws$timeSeriesListRequest(instrument = c("U:HES", "U:AXP", "@AEP","U:AFL", "U:AIG", "@ADI","@ALXN", "U:VLO", "@APA","@CMCSA" ,"@ANSS", "@AAPL", "@AMAT", "U:ALB", "U:ADM", "U:PNW"),
                                      datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market3 <- mydsws$timeSeriesListRequest(instrument = c("U:AEE", "@ADSK", "@ADP","U:AZO", "U:AVY", "U:BLL","U:BRK.B", "U:BAX", "U:BDX", "U:AME", "U:VZ","U:WRB", "U:BBY", "U:SLG"),
                                      datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market4 <- mydsws$timeSeriesListRequest(instrument = c("U:BIO", "U:YUM", "U:FE","U:BA","U:RHI", "U:BWA", "U:BSX", "@CHRW", "@TTWO", "U:MTD", "U:BMY", "U:OKE", "U:AVB", "U:URI", "U:SRE", "U:FDX","@VRSN"),
                                      datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market5 <- mydsws$timeSeriesListRequest(instrument = c("U:APH", "U:BF.B","U:PWR", "@CSX","U:COG", "U:CPB", "U:STZ", "U:CAH", "U:CAT", "@CTXS", "U:LUMN" ,"@CERN", "U:JPM", "U:CHD", "@CINF", "@CTAS", "@CSCO", "U:CLX", "U:KO","@CPRT"),
                                      datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market6 <-  mydsws$timeSeriesListRequest(instrument = c("U:CL","@MAR","U:CMA", "U:CAG", "U:ED","U:CMS", "U:COO", "U:GLW", "U:SEE", "U:CMI", "U:DHI", "U:DHR", "U:MCO", "@CTSH","U:TGT", "U:DE","U:MS","U:RSG", "U:DIS"),
                                       datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market7 <-  mydsws$timeSeriesListRequest(instrument = c("@DLTR", "U:DOV", "U:OMC", "U:DTE", "U:DRE", "U:FLS", "U:DRI","@EBAY", "U:BAC", "U:C", "U:EMN", "@CDNS", "@DISH", "U:ECL", "U:PKI", "@EA", "U:CRM", "U:EMR", "U:ATO","U:ESS"),
                                       datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market8 <-  mydsws$timeSeriesListRequest(instrument = c("U:ETR", "U:EOG", "U:EFX", "U:EQR", "U:EL","@EXPD", "U:XOM", "U:FMC", "U:NEE", "U:AIZ", "@FAST","U:FRT", "@FITB", "U:MTB", "@FISV", "@FLIR", "U:BEN", "U:FCX", "U:AJG", "U:GPS"),
                                       datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market9 <-  mydsws$timeSeriesListRequest(instrument = c("U:GD","U:GIS", "U:GPC","@GILD", "U:IT","U:MCK", "@NVDA", "U:GE","U:GWW", "U:HAL", "U:GS","@HAS","@HSIC", "U:HSY", "@FFIV","U:JNPR","@HOLX", "U:UNM", "U:HD","U:HRL", "U:CNP"),
                                       datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market10 <-  mydsws$timeSeriesListRequest(instrument = c("U:HUM", "@JBHT", "@HBAN", "@BIIB", "U:IEX", "U:ITW","@INTU", "@IDXX", "@INTC", "U:IFF", "U:IP","U:IPG", "U:J", "@JKHY", "@INCY", "U:JNJ", "U:HIG", "@KLAC","U:DVN", "U:K"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market11 <-  mydsws$timeSeriesListRequest(instrument = c("U:KEY", "U:KIM", "U:KMB", "U:BLK", "U:KR","@LRCX", "U:TDY", "U:PKG", "@AKAM", "U:LEG", "U:LEN", "U:LLY", "U:LNC", "U:UPS", "U:A", "U:LMT", "U:L", "U:CCL", "U:LOW", "U:D"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market12 <-  mydsws$timeSeriesListRequest(instrument = c("U:MGM", "U:MKC", "U:MCD","U:RE","U:EW","@HST","U:MMC", "U:MAS", "U:MLM", "U:MET", "@MXIM", "@ATVI", "U:CVS", "U:LH", "@MSFT", "@MU", "U:MAA", "@MCHP", "U:MMM", "U:MHK"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market13 <-  mydsws$timeSeriesListRequest(instrument = c("U:KSU", "@ILMN", "@XEL","U:F", "U:NOV", "@NTAP", "@NWL","U:NEM", "U:NVR", "U:NKE", "U:NSC", "U:NI","@NTRS", "U:NOC", "U:WFC", "U:NUE", "U:COF", "U:OXY","@ODFL", "U:ORCL"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market14 <-  mydsws$timeSeriesListRequest(instrument = c("@PCAR", "@EXC","U:PH","@PAYX", "@ALGN", "U:PPL", "@PEP","U:PFE", "U:COP", "U:PXD","U:MO","U:PNC", "U:PPG", "@IPGP", "@COST", "@TROW", "U:DGX", "U:PG","U:PGR", "U:PEG"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market15 <-  mydsws$timeSeriesListRequest(instrument = c("U:PHM", "U:GPN","@QCOM", "U:RJF", "U:O", "@REG","U:UDR", "@REGN", "U:RMD", "U:USB", "@ROST", "U:ROL", "U:ROP", "U:ROK", "U:RCL", "U:TRV", "U:FIS", "U:MRK", "U:SLB", "U:SCHW"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market16 <-  mydsws$timeSeriesListRequest(instrument = c("@POOL", "U:ZBH", "U:ABC", "@PFG","U:SHW", "U:CNC", "@SIVB", "U:SPG", "U:AOS", "U:SNA", "U:PRU", "U:AAP", "U:EIX", "U:SO","U:LUV", "U:T", "U:CVX", "U:STT","@SBUX", "U:PSA"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market17 <-  mydsws$timeSeriesListRequest(instrument = c("U:SYK", "@NFLX", "@SNPS", "U:SYY", "@ISRG", "U:TFX", "@TER","@TXN","U:TXT", "U:TMO","U:TIF", "U:DVA", "@TSCO", "U:TYL", "U:TSN", "U:MRO", "U:UNP", "U:UNH", "U:UHS", "U:VAR"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market18 <-  mydsws$timeSeriesListRequest(instrument = c("U:VTR", "U:VFC", "@VRTX", "U:VMC", "U:VNO", "U:WMT", "U:WM","U:WAT", "U:WST", "U:SJM", "@WDC","U:WAB", "U:WY","U:WHR", "@SWKS", "@WYNN", "@NDAQ", "@CME","U:WMB", "@LKQ"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market19 <-  mydsws$timeSeriesListRequest(instrument = c("@LNT","U:KMX", "@XLNX", "U:TJX", "@ZBRA", "@ZION", "NA","U:RF","U:DPZ", "U:EXR", "U:LVS", "U:DLR", "@MKTX", "U:CE","U:TAP", "@DXCM", "U:CF","U:AMP","U:UAA", "U:LYV"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market20 <-  mydsws$timeSeriesListRequest(instrument = c("U:CMG","U:TDG", "U:MA","U:HBI", "U:WU","U:BR","@PBCT", "U:DAL", "U:DFS", "U:CXO", "U:BK","@ULTA", "U:IVZ", "U:MSCI","U:PM","U:V", "U:AWK", "U:CB","@DISCA","@DISCK"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market21 <-  mydsws$timeSeriesListRequest(instrument = c("U:MPC", "U:FBHS" , "U:MOS", "U:KMI", "U:XYL", "U:SWK", "U:LYB", "U:PVH", "@GRMN", "U:HII", "U:PLD", "U:ACN", "U:HCA", "@VRSK","@UAL","U:FLT", "U:RL","U:FRC"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market22 <-  mydsws$timeSeriesListRequest(instrument = c("U:CBOE","@STX","U:DG","@FTNT", "U:MSI", "U:HFC", "U:TEL", "@ORLY", "U:GM","U:CBRE","@EXPE", "U:APTV","U:PSX", "U:AMT", "@FB", "U:DUK", "@FANG", "U:NOW", "@MDLZ"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market23 <-  mydsws$timeSeriesListRequest(instrument = c("U:ETN","U:ABBV","@TMUS", "U:ZTS", "U:NCLH","U:LB","@NWSA", "@NWS","@CDW","@AAL","U:INFO","@WLTW", "U:UA",  "U:BKR", "U:LW","U:IQV", "@BKNG", "U:FTI"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market24 <-  mydsws$timeSeriesListRequest(instrument = c("U:LDOS","@AVGO", "U:TPR", "U:TWTR","U:EVRG","U:ALLE","U:ICE","U:STE", "U:PRGO","U:VNT", "U:CI","U:DOW", "U:AMCR","U:PEAK","U:XRX", "@FOXA", "@FOX","U:AIV", "@NLOK"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market25 <-  mydsws$timeSeriesListRequest(instrument = c("U:DD","U:CARR","U:OTIS","U:GL","U:CTVA","U:LHX", "U:TT","U:HWM", "U:TFC", "@VIAC", "U:IR","U:PAYC" ,"U:AON", "U:PNR", "U:RTX", "@VTRS", "U:ANET","U:CTLT","U:SYF"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market26 <-  mydsws$timeSeriesListRequest(instrument = c("U:CFG", "U:KEYS","@QRVO", "U:ANTM","U:CCI", "U:MDT", "@WBA","U:IRM", "@EQIX", "U:ES","U:NLSN","@ETSY", "U:JCI", "@XRAY", "U:WRK"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

market27 <-  mydsws$timeSeriesListRequest(instrument = c("@KHC","U:FTV","U:SPGI","U:HLT", "@GOOGL","U:WELL","U:HPE", "@PYPL", "U:HPQ", "U:DXC", "@GOOG", "U:WEC", "@MNST", "U:LIN", "@SBAC", "@CHTR"),
                                        datatype = "MV", startDate = "2020-01-01", endDate = "2020-01-01" , frequency = "D")

MV <- merge.xts(market ,market2 ,market3 ,market4 ,market5 ,market6 ,market7 ,market8 ,market9 ,market10 ,market11 ,market12 ,market13 ,market14 ,market15 ,market16 ,
               market17 ,market18 ,market19 ,market20 ,market21 ,market22 ,market23 ,market24 ,market25 ,market26 ,market27)

MV[is.na(MV)] <- 0

mv <- as.data.frame(t(MV))

thres <- quantile(MV, p = 0.2)

big <- subset(mv, mv$`2020-01-01` > thres)


