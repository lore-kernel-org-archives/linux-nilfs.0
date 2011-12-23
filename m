From: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: [PATCH 2/2] nilfs-tune: catch and handle missing device argument
Date: Fri, 23 Dec 2011 09:11:16 -0600
Message-ID: <1324653076-13692-2-git-send-email-dan@archlinux.org>
References: <1324653076-13692-1-git-send-email-dan@archlinux.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=sXflhP6gMNghfypSV5Cuj/IzCMwd4TvMy4eyKX9e2pw=;
        b=M6WFRHP74H2szW4Tna6BP3bSamXclBK9EcyZtkp5sKTog4wjCfvOqREvDTzA+wBWrA
         b8XaAYM/j+2r8Ro/OuOztVY1xG1EIpQ9edJ2LLprb1KBGnXPz3srHkrQzdj+Dc3y9MHy
         oQ3P1FbrxLRFYz7OHpvAfG4+ynnUN+1HKMkdk=
In-Reply-To: <1324653076-13692-1-git-send-email-dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Before:
    $ nilfs-tune -l
    nilfs-tune 2.1.0
    cannot open device -l: No such file or directory

After:
    $ ./sbin/nilfs-tune/nilfs-tune -l
    nilfs-tune 2.1.0
    Usage: nilfs-tune [-h] [-l] [-i interval] [-L volume_name]
                      [-m block_max] [-O [^]feature[,...]]
                      [-U UUID] device

Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
---
 sbin/nilfs-tune/nilfs-tune.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sbin/nilfs-tune/nilfs-tune.c b/sbin/nilfs-tune/nilfs-tune.c
index cd5ef24..6655029 100644
--- a/sbin/nilfs-tune/nilfs-tune.c
+++ b/sbin/nilfs-tune/nilfs-tune.c
@@ -187,6 +187,12 @@ static void parse_options(int argc, char *argv[],
 			exit(EXIT_FAILURE);
 		}
 	}
+
+	if (optind == argc)
+	{
+		nilfs_tune_usage();
+		exit(EXIT_FAILURE);
+	}
 }
 
 #define MINUTE	(60)
-- 
1.7.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
