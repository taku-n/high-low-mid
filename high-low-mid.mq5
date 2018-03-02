#import "high-low-mid.dll"
double mid(const double high, const double low);
#import

#property indicator_chart_window

int OnInit()
{
	return INIT_SUCCEEDED;
}

int OnCalculate(const int       RATES_TOTAL,
		const int       PREV_CALCULATED,
		const datetime &TIME[],
		const double   &OPEN[],
		const double   &HIGH[],
		const double   &LOW[],
		const double   &CLOSE[],
		const long     &TICK_VOLUME[],
		const long     &VOLUME[],
		const int      &SPREAD[])
{
	double a[2] = {0.0, 0.0};

	if (CopyHigh(Symbol(), PERIOD_D1, 0, 2, a) < 0) {
		return RATES_TOTAL;
	}

	const double TODAY_HIGH     = a[1];
	const double YESTERDAY_HIGH = a[0];

	if (CopyLow(Symbol(), PERIOD_D1, 0, 2, a) < 0) {
		return RATES_TOTAL;
	}

	const double TODAY_LOW      = a[1];
	const double YESTERDAY_LOW  = a[0];

	const double TODAY_MID      = mid(TODAY_HIGH, TODAY_LOW);
	const double YESTERDAY_MID  = mid(YESTERDAY_HIGH, YESTERDAY_LOW);
	//
	// price initialization
	//

	if (ObjectFind(0, "High") < 0) {
		ObjectCreate(0, "High", OBJ_HLINE, 0, 0, TODAY_HIGH);
	} else {
		ObjectMove(0, "High", 0, 0, TODAY_HIGH);
	}

	if (ObjectFind(0, "Mid") < 0) {
		ObjectCreate(0, "Mid", OBJ_HLINE, 0, 0, TODAY_MID);
	} else {
		ObjectMove(0, "Mid", 0, 0, TODAY_MID);
	}

	if (ObjectFind(0, "Low") < 0) {
		ObjectCreate(0, "Low", OBJ_HLINE, 0, 0, TODAY_LOW);
	} else {
		ObjectMove(0, "Low", 0, 0, TODAY_LOW);
	}
	//
	// today
	//

	return RATES_TOTAL;
}

void OnDeinit(const int reason)
{
	ObjectDelete(0, "High");
	ObjectDelete(0, "Mid");
	ObjectDelete(0, "Low");
	ObjectDelete(0, "YesterdayHigh");
	ObjectDelete(0, "YesterdayMid");
	ObjectDelete(0, "YesterdayLow");
}
