
// Normally, these would be constants, but apparently reflection doesn't like that:
static int sizeof_boolean = (int)sizeof(bool);
static int sizeof_Char = (int)sizeof(Char);
static int sizeof_int = (int)sizeof(int);

static int sizeof_Float = (int)sizeof(Float);

static int sizeof_short = (int)sizeof(short);

// Currently just using this; I'd rather support everything.
static int sizeof_long = (int)sizeof(long long);
