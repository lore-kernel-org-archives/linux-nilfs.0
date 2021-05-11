From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 1/4] lib/vsprintf: Allow to override ISO 8601 date and time separator
Date: Tue, 11 May 2021 18:39:55 +0300
Message-ID: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

ISO 8601 defines 'T' as a separator between date and time. Though,
some ABIs use time and date with ' ' (space) separator instead.

Add a flavour to the %pt specifier to override default separator.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
v2: fixed the parameters set, renamed variable and dropped comment (Petr)
 Documentation/core-api/printk-formats.rst |  7 ++++++-
 lib/test_printf.c                         |  5 +++++
 lib/vsprintf.c                            | 22 +++++++++++++++++-----
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index f063a384c7c8..1dd4ebf0be79 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -514,9 +514,10 @@ Time and date
 ::
 
 	%pt[RT]			YYYY-mm-ddTHH:MM:SS
+	%pt[RT]s		YYYY-mm-dd HH:MM:SS
 	%pt[RT]d		YYYY-mm-dd
 	%pt[RT]t		HH:MM:SS
-	%pt[RT][dt][r]
+	%pt[RT][dt][r][s]
 
 For printing date and time as represented by::
 
@@ -528,6 +529,10 @@ in human readable format.
 By default year will be incremented by 1900 and month by 1.
 Use %pt[RT]r (raw) to suppress this behaviour.
 
+The %pt[RT]s (space) will override ISO 8601 separator by using ' ' (space)
+instead of 'T' (Capital T) between date and time. It won't have any effect
+when date or time is omitted.
+
 Passed by reference.
 
 struct clk
diff --git a/lib/test_printf.c b/lib/test_printf.c
index ec0d5976bb69..8ac71aee46af 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -528,6 +528,11 @@ time_and_date(void)
 	test("0119-00-04T15:32:23", "%ptTr", &t);
 	test("15:32:23|2019-01-04", "%ptTt|%ptTd", &t, &t);
 	test("15:32:23|0119-00-04", "%ptTtr|%ptTdr", &t, &t);
+
+	test("2019-01-04 15:32:23", "%ptTs", &t);
+	test("0119-00-04 15:32:23", "%ptTsr", &t);
+	test("15:32:23|2019-01-04", "%ptTts|%ptTds", &t, &t);
+	test("15:32:23|0119-00-04", "%ptTtrs|%ptTdrs", &t, &t);
 }
 
 static void __init
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f0c35d9b65bf..14a4e4e8a657 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1834,7 +1834,8 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	      struct printf_spec spec, const char *fmt)
 {
 	bool have_t = true, have_d = true;
-	bool raw = false;
+	bool raw = false, iso8601_separator = true;
+	bool found = true;
 	int count = 2;
 
 	if (check_pointer(&buf, end, tm, spec))
@@ -1851,14 +1852,25 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 		break;
 	}
 
-	raw = fmt[count] == 'r';
+	do {
+		switch (fmt[count++]) {
+		case 'r':
+			raw = true;
+			break;
+		case 's':
+			iso8601_separator = false;
+			break;
+		default:
+			found = false;
+			break;
+		}
+	} while (found);
 
 	if (have_d)
 		buf = date_str(buf, end, tm, raw);
 	if (have_d && have_t) {
-		/* Respect ISO 8601 */
 		if (buf < end)
-			*buf = 'T';
+			*buf = iso8601_separator ? 'T' : ' ';
 		buf++;
 	}
 	if (have_t)
@@ -2298,7 +2310,7 @@ early_param("no_hash_pointers", no_hash_pointers_enable);
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
  * - 'g' For block_device name (gendisk + partition number)
- * - 't[RT][dt][r]' For time and date as represented by:
+ * - 't[RT][dt][r][s]' For time and date as represented by:
  *      R    struct rtc_time
  *      T    time64_t
  * - 'C' For a clock, it prints the name (Common Clock Framework) or address
-- 
2.30.2

