#property indicator_chart_window

int OnInit()
{
	return INIT_SUCCEEDED;
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

int OnCalculate(const int       TOTAL,
		const int       PREV,
		const datetime &T[],
		const double   &O[],
		const double   &H[],
		const double   &L[],
		const double   &C[],
		const long     &TICK_VOL[],
		const long     &VOL[],
		const int      &SP[])
{
	double a[2] = {0.0, 0.0};

	//
	// daily price initialization
	//

	if (CopyHigh(Symbol(), PERIOD_D1, 0, 2, a) < 0) {
		return TOTAL;
	}

	const double TODAY_HIGH     = a[1];
	const double YESTERDAY_HIGH = a[0];

	if (CopyLow(Symbol(), PERIOD_D1, 0, 2, a) < 0) {
		return TOTAL;
	}

	const double TODAY_LOW      = a[1];
	const double YESTERDAY_LOW  = a[0];

	const double TODAY_MID      = mid(TODAY_HIGH, TODAY_LOW);
	const double YESTERDAY_MID  = mid(YESTERDAY_HIGH, YESTERDAY_LOW);

	//
	// weekly price initialization
	//

	if (CopyHigh(Symbol(), PERIOD_W1, 0, 2, a) < 0) {
		return TOTAL;
	}

	const double THIS_WEEK_HIGH = a[1];
	const double LAST_WEEK_HIGH = a[0];

	if (CopyLow(Symbol(), PERIOD_W1, 0, 2, a) < 0) {
		return TOTAL;
	}

	const double THIS_WEEK_LOW = a[1];
	const double LAST_WEEK_LOW = a[0];

	const double THIS_WEEK_MID = mid(THIS_WEEK_HIGH, THIS_WEEK_LOW);
	const double LAST_WEEK_MID = mid(LAST_WEEK_HIGH, LAST_WEEK_LOW);

	//
	// last week (rearmost)
	//
	draw_hline("LastWeekHigh", LAST_WEEK_HIGH, clrDodgerBlue, STYLE_SOLID, 4, 0, OBJ_PERIOD_D1);
	draw_hline("LastWeekMid",  LAST_WEEK_MID,  clrDodgerBlue, STYLE_DOT, 1, 0, OBJ_PERIOD_D1);
	draw_hline("LastWeekLow",  LAST_WEEK_LOW,  clrDodgerBlue, STYLE_SOLID, 4, 0, OBJ_PERIOD_D1);

	//
	// this week
	//
	draw_hline("ThisWeekHigh", THIS_WEEK_HIGH, clrYellow, STYLE_SOLID, 3, 0, OBJ_PERIOD_D1);
	draw_hline("ThisWeekMid",  THIS_WEEK_MID,  clrYellow, STYLE_DOT, 1, 0, OBJ_PERIOD_D1);
	draw_hline("ThisWeekLow",  THIS_WEEK_LOW,  clrYellow, STYLE_SOLID, 3, 0, OBJ_PERIOD_D1);

	//
	// yesterday
	//
	draw_hline("YesterdayHigh", YESTERDAY_HIGH, clrOrange, STYLE_SOLID, 2, 0, OBJ_PERIOD_H12);
	draw_hline("YesterdayMid",  YESTERDAY_MID,  clrOrange, STYLE_DOT, 1, 0, OBJ_PERIOD_H12);
	draw_hline("YesterdayLow",  YESTERDAY_LOW,  clrOrange, STYLE_SOLID, 2, 0, OBJ_PERIOD_H12);

	//
	// today (frontmost)
	//
	draw_hline("High", TODAY_HIGH, clrPink, STYLE_SOLID, 1, 0, OBJ_PERIOD_H12);
	draw_hline("Mid",  TODAY_MID,  clrPink, STYLE_DOT, 1, 0, OBJ_PERIOD_H12);
	draw_hline("Low",  TODAY_LOW,  clrPink, STYLE_SOLID, 1, 0, OBJ_PERIOD_H12);

	return TOTAL;
}

double mid(const double high, const double low)
{
	return (high + low) / 2.0;
}

//
// draw_hline()
//
// Create or move HLINE.
// If the WIDTH is more than 1, the STYLE is ignored.
// Z order does not change which line is at the top and visible.
// If two lines have a same price, the line drawn at last is at the top and visible.
//
void draw_hline(const string NAME, const double PRICE, const color CLR,
		const ENUM_LINE_STYLE STYLE, const int WIDTH, const long Z, const int TIMEFRAME)
{
	if (ObjectFind(0, NAME) < 0) {  // not exist
		ObjectCreate(0, NAME, OBJ_HLINE, 0, 0, PRICE);
		ObjectSetInteger(0, NAME, OBJPROP_COLOR, CLR);
		ObjectSetInteger(0, NAME, OBJPROP_STYLE, STYLE);
		ObjectSetInteger(0, NAME, OBJPROP_WIDTH, WIDTH);
		ObjectSetInteger(0, NAME, OBJPROP_ZORDER, Z);
		ObjectSetInteger(0, NAME, OBJPROP_TIMEFRAMES,
				visibility_flags_less_or_equal(TIMEFRAME));
	} else {  // already exist
		ObjectMove(0, NAME, 0, 0, PRICE);
	}
}

int visibility_flags_less_or_equal(const int TIMEFRAME)
{
	const int TIMEFRAMES[] = {
			OBJ_PERIOD_M1,
			OBJ_PERIOD_M2,
			OBJ_PERIOD_M3,
			OBJ_PERIOD_M4,
			OBJ_PERIOD_M5,
			OBJ_PERIOD_M6,
			OBJ_PERIOD_M10,
			OBJ_PERIOD_M12,
			OBJ_PERIOD_M15,
			OBJ_PERIOD_M20,
			OBJ_PERIOD_M30,
			OBJ_PERIOD_H1,
			OBJ_PERIOD_H2,
			OBJ_PERIOD_H3,
			OBJ_PERIOD_H4,
			OBJ_PERIOD_H6,
			OBJ_PERIOD_H8,
			OBJ_PERIOD_H12,
			OBJ_PERIOD_D1,
			OBJ_PERIOD_W1,
			OBJ_PERIOD_MN1};

	int flags = OBJ_NO_PERIODS;
	for (int i = 0; i < sizeof(TIMEFRAMES); i++) {
		if (TIMEFRAMES[i] <= TIMEFRAME) {
			flags += TIMEFRAMES[i];
		} else {
			break;
		}
	}

	return flags;
}
