require(devtools)
install_github("CharlesCara/pricestreamDSWS2R")
githubinstall("CharlesCara/pricestreamDSWS2R")
options(pricestream.Username = "ZUSI007")
options(pricestream.Password = "OCEAN248")
require("pricestreamDSWS2R")
require("xts")
# http://product.pricestream.com/dsws/1.0/DSLogon.aspx?persisttoken=true&appgroup=DSLegacy&srcappver=5.2.12131.0&prepopulate=&env=&srcapp=ChartWeb&redirect=%2f%2fproduct.pricestream.com%2fDSCharting%2fGateway.aspx%3fappgroup%3dDSLegacy

mydsws <- dsws$new()

ticker <- mydsws$listRequest("LS&PCOMP", datatype = "MNEM", requestDate = "0D")
ticker <- gsub("@", "", ticker[,2])
ticker <- gsub("U:", "", ticker)
ticker


price <- mydsws$timeSeriesListRequest(instrument = c( "@AMZN", "U:ABT", "U:AES", "@ABMD", "U:IBM", "@AMD","@ADBE", "U:ARE", "U:APD", "U:ALK", "U:BXP", "U:ALL","U:HON", "@AMGN"),
                                     datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price2 <- mydsws$timeSeriesListRequest(instrument = c("U:HES", "U:AXP", "@AEP","U:AFL", "U:AIG", "@ADI","@ALXN", "U:VLO", "@APA","@CMCSA" ,"@ANSS", "@AAPL", "@AMAT", "U:ALB", "U:ADM", "U:PNW"),
                                      datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price3 <- mydsws$timeSeriesListRequest(instrument = c("U:AEE", "@ADSK", "@ADP","U:AZO", "U:AVY", "U:BLL","U:BRK.B", "U:BAX", "U:BDX", "U:AME", "U:VZ","U:WRB", "U:BBY", "U:SLG"),
                                      datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price4 <- mydsws$timeSeriesListRequest(instrument = c("U:BIO", "U:YUM", "U:FE","U:BA","U:RHI", "U:BWA", "U:BSX", "@CHRW", "@TTWO", "U:MTD", "U:BMY", "U:OKE", "U:AVB", "U:URI", "U:SRE", "U:FDX","@VRSN"),
                                      datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price5 <- mydsws$timeSeriesListRequest(instrument = c("U:APH", "U:BF.B","U:PWR", "@CSX","U:COG", "U:CPB", "U:STZ", "U:CAH", "U:CAT", "@CTXS", "U:LUMN" ,"@CERN", "U:JPM", "U:CHD", "@CINF", "@CTAS", "@CSCO", "U:CLX", "U:KO","@CPRT"),
                                      datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price6 <-  mydsws$timeSeriesListRequest(instrument = c("U:CL","@MAR","U:CMA", "U:CAG", "U:ED","U:CMS", "U:COO", "U:GLW", "U:SEE", "U:CMI", "U:DHI", "U:DHR", "U:MCO", "@CTSH","U:TGT", "U:DE","U:MS","U:RSG", "U:DIS"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price7 <-  mydsws$timeSeriesListRequest(instrument = c("@DLTR", "U:DOV", "U:OMC", "U:DTE", "U:DRE", "U:FLS", "U:DRI","@EBAY", "U:BAC", "U:C", "U:EMN", "@CDNS", "@DISH", "U:ECL", "U:PKI", "@EA", "U:CRM", "U:EMR", "U:ATO","U:ESS"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price8 <-  mydsws$timeSeriesListRequest(instrument = c("U:ETR", "U:EOG", "U:EFX", "U:EQR", "U:EL","@EXPD", "U:XOM", "U:FMC", "U:NEE", "U:AIZ", "@FAST","U:FRT", "@FITB", "U:MTB", "@FISV", "@FLIR", "U:BEN", "U:FCX", "U:AJG", "U:GPS"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price9 <-  mydsws$timeSeriesListRequest(instrument = c("U:GD","U:GIS", "U:GPC","@GILD", "U:IT","U:MCK", "@NVDA", "U:GE","U:GWW", "U:HAL", "U:GS","@HAS","@HSIC", "U:HSY", "@FFIV","U:JNPR","@HOLX", "U:UNM", "U:HD","U:HRL", "U:CNP"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price10 <-  mydsws$timeSeriesListRequest(instrument = c("U:HUM", "@JBHT", "@HBAN", "@BIIB", "U:IEX", "U:ITW","@INTU", "@IDXX", "@INTC", "U:IFF", "U:IP","U:IPG", "U:J", "@JKHY", "@INCY", "U:JNJ", "U:HIG", "@KLAC","U:DVN", "U:K"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price11 <-  mydsws$timeSeriesListRequest(instrument = c("U:KEY", "U:KIM", "U:KMB", "U:BLK", "U:KR","@LRCX", "U:TDY", "U:PKG", "@AKAM", "U:LEG", "U:LEN", "U:LLY", "U:LNC", "U:UPS", "U:A", "U:LMT", "U:L", "U:CCL", "U:LOW", "U:D"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price12 <-  mydsws$timeSeriesListRequest(instrument = c("U:MGM", "U:MKC", "U:MCD","U:RE","U:EW","@HST","U:MMC", "U:MAS", "U:MLM", "U:MET", "@MXIM", "@ATVI", "U:CVS", "U:LH", "@MSFT", "@MU", "U:MAA", "@MCHP", "U:MMM", "U:MHK"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price13 <-  mydsws$timeSeriesListRequest(instrument = c("U:KSU", "@ILMN", "@XEL","U:F", "U:NOV", "@NTAP", "@NWL","U:NEM", "U:NVR", "U:NKE", "U:NSC", "U:NI","@NTRS", "U:NOC", "U:WFC", "U:NUE", "U:COF", "U:OXY","@ODFL", "U:ORCL"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price14 <-  mydsws$timeSeriesListRequest(instrument = c("@PCAR", "@EXC","U:PH","@PAYX", "@ALGN", "U:PPL", "@PEP","U:PFE", "U:COP", "U:PXD","U:MO","U:PNC", "U:PPG", "@IPGP", "@COST", "@TROW", "U:DGX", "U:PG","U:PGR", "U:PEG"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price15 <-  mydsws$timeSeriesListRequest(instrument = c("U:PHM", "U:GPN","@QCOM", "U:RJF", "U:O", "@REG","U:UDR", "@REGN", "U:RMD", "U:USB", "@ROST", "U:ROL", "U:ROP", "U:ROK", "U:RCL", "U:TRV", "U:FIS", "U:MRK", "U:SLB", "U:SCHW"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price16 <-  mydsws$timeSeriesListRequest(instrument = c("@POOL", "U:ZBH", "U:ABC", "@PFG","U:SHW", "U:CNC", "@SIVB", "U:SPG", "U:AOS", "U:SNA", "U:PRU", "U:AAP", "U:EIX", "U:SO","U:LUV", "U:T", "U:CVX", "U:STT","@SBUX", "U:PSA"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price17 <-  mydsws$timeSeriesListRequest(instrument = c("U:SYK", "@NFLX", "@SNPS", "U:SYY", "@ISRG", "U:TFX", "@TER","@TXN","U:TXT", "U:TMO","U:TIF", "U:DVA", "@TSCO", "U:TYL", "U:TSN", "U:MRO", "U:UNP", "U:UNH", "U:UHS", "U:VAR"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price18 <-  mydsws$timeSeriesListRequest(instrument = c("U:VTR", "U:VFC", "@VRTX", "U:VMC", "U:VNO", "U:WMT", "U:WM","U:WAT", "U:WST", "U:SJM", "@WDC","U:WAB", "U:WY","U:WHR", "@SWKS", "@WYNN", "@NDAQ", "@CME","U:WMB", "@LKQ"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price19 <-  mydsws$timeSeriesListRequest(instrument = c("@LNT","U:KMX", "@XLNX", "U:TJX", "@ZBRA", "@ZION", "NA","U:RF","U:DPZ", "U:EXR", "U:LVS", "U:DLR", "@MKTX", "U:CE","U:TAP", "@DXCM", "U:CF","U:AMP","U:UAA", "U:LYV"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price20 <-  mydsws$timeSeriesListRequest(instrument = c("U:CMG","U:TDG", "U:MA","U:HBI", "U:WU","U:BR","@PBCT", "U:DAL", "U:DFS", "U:CXO", "U:BK","@ULTA", "U:IVZ", "U:MSCI","U:PM","U:V", "U:AWK", "U:CB","@DISCA","@DISCK"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price21 <-  mydsws$timeSeriesListRequest(instrument = c("U:MPC", "U:FBHS" , "U:MOS", "U:KMI", "U:XYL", "U:SWK", "U:LYB", "U:PVH", "@GRMN", "U:HII", "U:PLD", "U:ACN", "U:HCA", "@VRSK","@UAL","U:FLT", "U:RL","U:FRC"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price22 <-  mydsws$timeSeriesListRequest(instrument = c("U:CBOE","@STX","U:DG","@FTNT", "U:MSI", "U:HFC", "U:TEL", "@ORLY", "U:GM","U:CBRE","@EXPE", "U:APTV","U:PSX", "U:AMT", "@FB", "U:DUK", "@FANG", "U:NOW", "@MDLZ"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price23 <-  mydsws$timeSeriesListRequest(instrument = c("U:ETN","U:ABBV","@TMUS", "U:ZTS", "U:NCLH","U:LB","@NWSA", "@NWS","@CDW","@AAL","U:INFO","@WLTW", "U:UA",  "U:BKR", "U:LW","U:IQV", "@BKNG", "U:FTI"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price24 <-  mydsws$timeSeriesListRequest(instrument = c("U:LDOS","@AVGO", "U:TPR", "U:TWTR","U:EVRG","U:ALLE","U:ICE","U:STE", "U:PRGO","U:VNT", "U:CI","U:DOW", "U:AMCR","U:PEAK","U:XRX", "@FOXA", "@FOX","U:AIV", "@NLOK"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price25 <-  mydsws$timeSeriesListRequest(instrument = c("U:DD","U:CARR","U:OTIS","U:GL","U:CTVA","U:LHX", "U:TT","U:HWM", "U:TFC", "@VIAC", "U:IR","U:PAYC" ,"U:AON", "U:PNR", "U:RTX", "@VTRS", "U:ANET","U:CTLT","U:SYF"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price26 <-  mydsws$timeSeriesListRequest(instrument = c("U:CFG", "U:KEYS","@QRVO", "U:ANTM","U:CCI", "U:MDT", "@WBA","U:IRM", "@EQIX", "U:ES","U:NLSN","@ETSY", "U:JCI", "@XRAY", "U:WRK"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

price27 <-  mydsws$timeSeriesListRequest(instrument = c("@KHC","U:FTV","U:SPGI","U:HLT", "@GOOGL","U:WELL","U:HPE", "@PYPL", "U:HPQ", "U:DXC", "@GOOG", "U:WEC", "@MNST", "U:LIN", "@SBAC", "@CHTR"),
                                       datatype = "P", startDate = "2019-01-01", endDate = "2020-01-01" , frequency = "D")

P <- merge.xts(price ,price2 ,price3 ,price4 ,price5 ,price6 ,price7 ,price8 ,price9 ,price10 ,price11 ,price12 ,price13 ,price14 ,price15 ,price16 ,
                 price17 ,price18 ,price19 ,price20 ,price21 ,price22 ,price23 ,price24 ,price25 ,price26 ,price27 )

p <- as.data.frame(P)

p <- as.data.frame(p[, row.names(big)])

library("rio")
install_formapts()
export(p, "p.csv")
