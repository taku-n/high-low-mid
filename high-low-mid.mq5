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
	// daily price initialization
	//

	if (CopyHigh(Symbol(), PERIOD_W1, 0, 2, a) < 0) {
		return RATES_TOTAL;
	}

	const double THIS_WEEK_HIGH = a[1];
	const double LAST_WEEK_HIGH = a[0];

	if (CopyLow(Symbol(), PERIOD_W1, 0, 2, a) < 0) {
		return RATES_TOTAL;
	}

	const double THIS_WEEK_LOW = a[1];
	const double LAST_WEEK_LOW = a[0];

	const double THIS_WEEK_MID = mid(THIS_WEEK_HIGH, THIS_WEEK_LOW);
	const double LAST_WEEK_MID = mid(LAST_WEEK_HIGH, LAST_WEEK_LOW);
	//
	// weekly price initialization
	//

	draw_hline("LastWeekHigh", LAST_WEEK_HIGH, clrDodgerBlue, STYLE_SOLID,
			4, 0);
	draw_hline("LastWeekMid",  LAST_WEEK_MID,  clrDodgerBlue, STYLE_SOLID,
			4, 0);
	draw_hline("LastWeekLow",  LAST_WEEK_LOW,  clrDodgerBlue, STYLE_SOLID,
			4, 0);
	//
	// last week
	//

	draw_hline("ThisWeekHigh", THIS_WEEK_HIGH, clrYellow, STYLE_SOLID, 3,
			0);
	draw_hline("ThisWeekMid",  THIS_WEEK_MID,  clrYellow, STYLE_SOLID, 3,
			0);
	draw_hline("ThisWeekLow",  THIS_WEEK_LOW,  clrYellow, STYLE_SOLID, 3,
			0);
	//
	// this week
	//

	draw_hline("YesterdayHigh", YESTERDAY_HIGH, clrOrange, STYLE_SOLID, 2,
			0);
	draw_hline("YesterdayMid",  YESTERDAY_MID,  clrOrange, STYLE_SOLID, 2,
			0);
	draw_hline("YesterdayLow",  YESTERDAY_LOW,  clrOrange, STYLE_SOLID, 2,
			0);
	//
	// yesterday
	//

	draw_hline("High", TODAY_HIGH, clrPink, STYLE_SOLID, 1, 0);
	draw_hline("Mid",  TODAY_MID,  clrPink, STYLE_SOLID, 1, 0);
	draw_hline("Low",  TODAY_LOW,  clrPink, STYLE_SOLID, 1, 0);
	//
	// today
	//
	//
	// If two lines have a same price, the line drawn at last is at the top
	// and visible.
	//

	/*
	Print("TODAY_HIGH: ", TODAY_HIGH, ", TODAY_MID: ", TODAY_MID,
			", TODAY_LOW: ", TODAY_LOW);
	Print("YESTERDAY_HIGH: ", YESTERDAY_HIGH, ", YESTERDAY_MID: ",
			YESTERDAY_MID, ", YESTERDAY_LOW: ", YESTERDAY_LOW);
	Print("THIS_WEEK_HIGH: ", THIS_WEEK_HIGH, ", THIS_WEEK_MID: ",
			THIS_WEEK_MID, ", THIS_WEEK_LOW: ", THIS_WEEK_LOW);
	Print("LAST_WEEK_HIGH: ", LAST_WEEK_HIGH, ", LAST_WEEK_MID: ",
			LAST_WEEK_MID, ", LAST_WEEK_LOW: ", LAST_WEEK_LOW);
	*/

	return RATES_TOTAL;
}

void OnDeinit(const int REASON)
{
	ObjectDelete(0, "High");
	ObjectDelete(0, "Mid");
	ObjectDelete(0, "Low");

	ObjectDelete(0, "YesterdayHigh");
	ObjectDelete(0, "YesterdayMid");
	ObjectDelete(0, "YesterdayLow");

	ObjectDelete(0, "ThisWeekHigh");
	ObjectDelete(0, "ThisWeekMid");
	ObjectDelete(0, "ThisWeekLow");

	ObjectDelete(0, "LastWeekHigh");
	ObjectDelete(0, "LastWeekMid");
	ObjectDelete(0, "LastWeekLow");
}

void draw_hline(const string NAME, const double PRICE, const color CLR,
		const ENUM_LINE_STYLE STYLE, const int WIDTH, const long Z)
{
	if (ObjectFind(0, NAME) < 0) {
	// not exist
		ObjectCreate(0, NAME, OBJ_HLINE, 0, 0, PRICE);
		ObjectSetInteger(0, NAME, OBJPROP_COLOR, CLR);
		ObjectSetInteger(0, NAME, OBJPROP_STYLE, STYLE);
		ObjectSetInteger(0, NAME, OBJPROP_WIDTH, WIDTH);
		ObjectSetInteger(0, NAME, OBJPROP_ZORDER, Z);
	} else {
	// already exist
		ObjectMove(0, NAME, 0, 0, PRICE);
	}
}
//
// Create or move HLINE.
// If the WIDTH is more than 1, the STYLE is ignored.
// Z order does not change which line is at the top and visible.
//
