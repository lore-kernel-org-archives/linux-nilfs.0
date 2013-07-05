From: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>
Subject: searching checkpoints contaning an inode (or a filename)
Date: Fri, 5 Jul 2013 16:17:01 -0400
Message-ID: <20130705201701.GE23851@taesoo.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=XoeuLEufOpTLvI4zVG081x+buZBbPLnDzVArjz51xRg=;
        b=yxSVOtu9JRx5uq68LPQzIOUmp0BszQqKd3AwHhcMOJOx3hBCDQje4AabbIFzC4mnqE
         /lv/lqE0MM7hLP2FVMs0U8bYB2KD2bSjoiD6y1rfaQTW6Xcsy2tWe6eMyv/BIOaqmkLW
         nOug4jHGw4t2b8irWd/Y/jiLkCe4zEaWMJsukuCZeXXimhOoNKvbbqh7yHUbuykQiEow
         BYVVGt/TfyuHvGFkIVi9ju9bwo9S6KRO2H+RtN/5jGFg0gODsiI1hAIoxzrvtvLaQdhv
         yHdI0bias4pseIrW5cATx9zjTCHciMtLOnzE8UFXILJT9LsSooqmEjQgoow3xtAuZe5M
         C7xg==
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi nilfs,

I am evaluating nilfs for using it in my machine. There are a few
questions regarding usages:

q1. how can I enumerate a list of cps, given a filename?
 (I know I can mount each cp to check whether there is my file or
 not, as time-machine (in mac) does)

q2. compute diff or cat against previous files in a specific cp?
 (instead of mounting and copying them individually to my /tmp)

q3. using nilfs as rootfs?
 (I couldn't find any people using nilfs for rootfs. Are there any
 issue on that? or just matter of performance? on updates for
 example)

Nilfs looks conceptually nice and clean, so I can trust the
implementation or jump directly into modifying code. Do you have any
design notes (other than one in /Documentation and overview-nilfs1.pdf).

Thank you in advance.
Taesoo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
