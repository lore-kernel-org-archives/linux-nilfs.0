From: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Subject: couldn't mount because of unsupported optional features
 (477e7ad1e859f753)
Date: Thu, 30 Dec 2021 09:16:37 +0000
Message-ID: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=smtp-gateway.net; s=dkim2k; h=Date:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=A9Kmo6hdjHYTyOizCQiXQsMlZ3MMb34tY2IHqV33drI=; b=GVZJovV39ZeMMnF6ewdyuS4SIn
        ru/J56RitbWeNHBJDaqIlAWzm9HGE045+0K/yV+b1u/fD0Q4lQyW85wwyy+SD7xrhetqg4/vPSZ8K
        yYuxhQYzem+g2f6C/zcEsCczVXAREErMnSyu96bHeMLUg0ZwTCg+E51uM/AVK+viC8iBsgtETndoJ
        Ud49eSkCoHxSQaP1M9PirIF6ZbButEDR0G0saaN2CBN/AhEYDfArzQYRTGvhtw6f5SmCsNs40bZ9T
        pXAvkJLlFqABVEsbDipb96zJFJJ8TAqY6HMM1jcJRO2ikhi31tXD6g1djxYB7HHZTeUhzHObep7eG
        PqJ 
Content-Language: en-GB
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Trying to mount a NILFS partition fails with "couldn't mount because of
unsupported optional features (477e7ad1e859f753)". Neither the OS nor
the partition have been touched/modified since the last successful
mount. Might the underlying block device be corrupt? Is
"477e7ad1e859f753" a valid set of feature flag?

Thank you

Hendrik


