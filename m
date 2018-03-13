From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v9 01/61] mac80211_hwsim: Use DEFINE_IDA
Date: Tue, 13 Mar 2018 06:25:39 -0700
Message-ID: <20180313132639.17387-2-willy@infradead.org>
References: <20180313132639.17387-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D7QQH4/81PvxyUcinTLWEgPArKyrlsg2Smenx1TvoRs=; b=Ty/FcSQb6eMUNmNa2M9FHXtBR
        h3/JaGxF+A6PURShQlk/bBB4bVvdVArOtUUC7XGymsZLIOi5Y33xfQkxQ/K+0GgCRklKEaEBiO7IH
        185z16CDmGsiGEtq0vOSqlxFED5d0nKIP/EcBnZy8MImXEl3cZyrh3nW5YWXgZMBfPduJQltE/AQg
        /x4YaGKkP8NBZPdYOWQIvCDJmLOyN+uyz8EBsOC1QnN2vWNHe418hTYdINNjKdd7cmwT+3j2xrljT
        gfxEgpk6e4rgY2v/HLWl68yJqDSvALp4zvSDcI8Mi7GpFWbiYu1AxwegJ8smbjo2oyArbYozT7EYU
    
In-Reply-To: <20180313132639.17387-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

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

