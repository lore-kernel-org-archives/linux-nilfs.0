From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 4/4] usb: host: xhci-tegra: Switch to use %ptTs
Date: Tue, 11 May 2021 18:39:58 +0300
Message-ID: <20210511153958.34527-4-andriy.shevchenko@linux.intel.com>
References: <20210511153958.34527-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210511153958.34527-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, JC Kuo <jckuo-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Sumit Garg <sumit.garg-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kgdb-bugreport-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mathias Nyman <mathias.nyman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Wessel <jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Use %ptTs instead of open coded variant to print contents
of time64_t type in human readable form.

Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Hunter <jonathanh-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
---
v2: collected tags
 drivers/usb/host/xhci-tegra.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index ce97ff054c68..937b78cba89b 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -890,7 +890,6 @@ static int tegra_xusb_load_firmware(struct tegra_xusb *tegra)
 	struct xhci_op_regs __iomem *op;
 	unsigned long timeout;
 	time64_t timestamp;
-	struct tm time;
 	u64 address;
 	u32 value;
 	int err;
@@ -987,11 +986,8 @@ static int tegra_xusb_load_firmware(struct tegra_xusb *tegra)
 	}
 
 	timestamp = le32_to_cpu(header->fwimg_created_time);
-	time64_to_tm(timestamp, 0, &time);
 
-	dev_info(dev, "Firmware timestamp: %ld-%02d-%02d %02d:%02d:%02d UTC\n",
-		 time.tm_year + 1900, time.tm_mon + 1, time.tm_mday,
-		 time.tm_hour, time.tm_min, time.tm_sec);
+	dev_info(dev, "Firmware timestamp: %ptTs UTC\n", &timestamp);
 
 	return 0;
 }
-- 
2.30.2

