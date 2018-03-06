From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v8 01/63] mac80211_hwsim: Use DEFINE_IDA
Date: Tue,  6 Mar 2018 11:23:11 -0800
Message-ID: <20180306192413.5499-2-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D7QQH4/81PvxyUcinTLWEgPArKyrlsg2Smenx1TvoRs=; b=qotdK5mplwyu8UdNk5QO0naiW
        P2BQeUARUsHFxYl4siwhH09cmaPNg8Zqz1t48sMMp85g2cE49vsJPyMhge+tAYvNugdGtUgSeKKkA
        LFCU6hjhr3KtxLaPJLiOIfeW2JOa3A34KZmcEhgBIDtqhg/GCkbop6xlzxbQbLPFII/Mxkq3JDVnK
        rn+ah1yd1l0qePVcAUlkkLs8MgeQyL/CtnVBpjv+jqkE++XsuGsMAbjYZnlkaNv08CrhhRgl1WewK
        8yym9UQcRGlgn41yjIoCu4bNSxZGt1EtfXe4IjO7w+bnhTZbG+RzBWlCBJcTm0ZVh2dUiVwozW2Yu
    
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is preferred to opencoding an IDA_INIT.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b6c3640a94f..8bffd6ebc03e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -253,7 +253,7 @@ static inline void hwsim_clear_chanctx_magic(struct ieee80211_chanctx_conf *c)
 
 static unsigned int hwsim_net_id;
 
-static struct ida hwsim_netgroup_ida = IDA_INIT;
+static DEFINE_IDA(hwsim_netgroup_ida);
 
 struct hwsim_net {
 	int netgroup;
-- 
2.16.1

