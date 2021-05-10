From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/4] lib/vsprintf: Allow to override
 date and time separator
Date: Mon, 10 May 2021 18:04:10 +0300
Message-ID: <20210510150413.59356-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kgdb-bugreport-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:MIME-Version:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=jdYJkkj29NwpYVvjgfY8FHXag2cPo8Xu+j//oZAxZsI=; b=jZY1ubTOqwAssWQ5qnsFCi5xpN
 tV6X8OOsNqVqkeOycHoLLuokVTnTKX2EwKfp2o6avzyGMXmgTrLeqvJxS4HSAkd4TlKxVXKclOzRF
 La60sIQJF7cIWcsuaYJRkVHhCkuVMftLP2C5wHfgcrX0sxJ/70W2KxaZK18F30wHWY6Y=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From
 :Sender:Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
 References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
 List-Owner:List-Archive; bh=jdYJkkj29NwpYVvjgfY8FHXag2cPo8Xu+j//oZAxZsI=; b=S
 LEaXvrOv40w/mkZR6H7TFtMAQpDcZxTbptcy9WKJA72eruLNNJ7N+A/0jUrRiwIdvUahLm3mhXLIj
 MpvrpnNdaHrv3NprbFQhwt8H8J69ye9yvt4UjWiTyHGqQvdu8i/d3Qbgqr7YCQBgZFcDcwF+cSoLs
 9mmVCsxOoa0cxAGs=;
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/kgdb-bugreport>, 
 <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=kgdb-bugreport>
List-Post: <mailto:kgdb-bugreport@lists.sourceforge.net>
List-Help: <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport>, 
 <mailto:kgdb-bugreport-request@lists.sourceforge.net?subject=subscribe>
Errors-To: kgdb-bugreport-bounces@lists.sourceforge.net
To: Petr Mladek <pmladek@suse.com>, JC Kuo <jckuo@nvidia.com>, Joe Perches <joe@perches.com>, Sumit Garg <sumit.garg@linaro.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org, linux-nilfs@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Daniel Thompson <daniel.thompson@linaro.org>, Mathias Nyman <mathias.nyman@intel.com>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steven Rostedt <rostedt@goodmis.org>, Jonathan Hunter <jonathanh@nvidia.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Thierry Reding <thierry.reding@gmail.com>, Jason Wessel <jason.wessel@windriver.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>

ISO 8601 defines 'T' as a separator between date and time. Though,
some ABIs use time and date with ' ' separator instead.

Add a flavour to the %pt specifier to override default separator.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/core-api/printk-formats.rst |  6 +++++-
 lib/test_printf.c                         |  5 +++++
 lib/vsprintf.c                            | 19 ++++++++++++++++---
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index f063a384c7c8..bc85fd4685e7 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -514,9 +514,10 @@ Time and date
 ::
 
 	%pt[RT]			YYYY-mm-ddTHH:MM:SS
+	%pt[RT]s		YYYY-mm-dd HH:MM:SS
 	%pt[RT]d		YYYY-mm-dd
 	%pt[RT]t		HH:MM:SS
-	%pt[RT][dt][r]
+	%pt[RT][dt][rs]
 
 For printing date and time as represented by::
 
@@ -528,6 +529,9 @@ in human readable format.
 By default year will be incremented by 1900 and month by 1.
 Use %pt[RT]r (raw) to suppress this behaviour.
 
+The %pt[RT]s (space) will override ISO 8601 by using ' ' instead of 'T'
+between date and time. It won't have any effect when date or time is omitted.
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
index f0c35d9b65bf..5f36c7a43cdc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1834,7 +1834,8 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 	      struct printf_spec spec, const char *fmt)
 {
 	bool have_t = true, have_d = true;
-	bool raw = false;
+	bool raw = false, space = false;
+	bool found = true;
 	int count = 2;
 
 	if (check_pointer(&buf, end, tm, spec))
@@ -1851,14 +1852,26 @@ char *rtc_str(char *buf, char *end, const struct rtc_time *tm,
 		break;
 	}
 
-	raw = fmt[count] == 'r';
+	do {
+		switch (fmt[count++]) {
+		case 'r':
+			raw = true;
+			break;
+		case 's':
+			space = true;
+			break;
+		default:
+			found = false;
+			break;
+		}
+	} while (found);
 
 	if (have_d)
 		buf = date_str(buf, end, tm, raw);
 	if (have_d && have_t) {
 		/* Respect ISO 8601 */
 		if (buf < end)
-			*buf = 'T';
+			*buf = space ? ' ' : 'T';
 		buf++;
 	}
 	if (have_t)
-- 
2.30.2
