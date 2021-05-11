From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] kdb: Switch to use %ptTs
Date: Tue, 11 May 2021 18:39:56 +0300
Message-ID: <20210511153958.34527-2-andriy.shevchenko@linux.intel.com>
References: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek@suse.com>, JC Kuo <jckuo@nvidia.com>, Joe Perches <joe@perches.com>, Sumit Garg <sumit.garg@linaro.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org, linux-nilfs@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jonathan Corbet <corbet@lwn.net>, Mathias Nyman <mathias.nyman@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thierry Reding <thierry.reding@gmail.com>, Jonathan Hunter <jonathanh@nvidia.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Jason Wessel <jason.wessel@windriver.com>, Daniel Thompson <daniel.thompson@linaro.org>, Douglas Anderson <dianders@chromium.org>

Use %ptTs instead of open-coded variant to print contents
of time64_t type in human readable form.

Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
---
v2: collected tags
 kernel/debug/kdb/kdb_main.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 1baa96a2ecb8..622410c45da1 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2488,7 +2488,6 @@ static void kdb_sysinfo(struct sysinfo *val)
 static int kdb_summary(int argc, const char **argv)
 {
 	time64_t now;
-	struct tm tm;
 	struct sysinfo val;
 
 	if (argc)
@@ -2502,13 +2501,7 @@ static int kdb_summary(int argc, const char **argv)
 	kdb_printf("domainname %s\n", init_uts_ns.name.domainname);
 
 	now = __ktime_get_real_seconds();
-	time64_to_tm(now, 0, &tm);
-	kdb_printf("date       %04ld-%02d-%02d %02d:%02d:%02d "
-		   "tz_minuteswest %d\n",
-		1900+tm.tm_year, tm.tm_mon+1, tm.tm_mday,
-		tm.tm_hour, tm.tm_min, tm.tm_sec,
-		sys_tz.tz_minuteswest);
-
+	kdb_printf("date       %ptTs tz_minuteswest %d\n", &now, sys_tz.tz_minuteswest);
 	kdb_sysinfo(&val);
 	kdb_printf("uptime     ");
 	if (val.uptime > (24*60*60)) {
-- 
2.30.2

