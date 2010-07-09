From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: How to turn off checkpoints
Date: Fri, 9 Jul 2010 10:11:29 +0900
Message-ID: <AANLkTimfmo7MOXJpEgE-0psC6jnCt0S0BRopxoxWrc_l@mail.gmail.com>
References: <1278593787.8104.19.camel@Stanowisko-25>
	<AANLkTimD74YP7GC1imbiRnKGETOfLYlGMkO682GqeU90@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:sender:received
         :in-reply-to:references:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        bh=B0K7wGQjsUdRBMjJdhOWwq587E4OChlzt8s4oK1od6s=;
        b=wADrAL8NP2avuaLkaa36EEw0yBBBCnHjam0jinoOqPP7qdNXTSiSG2HgKTGJOn1Tgl
         yW05oIR1yRiJvN/sBEJ33CjIs6YyxOKKde25oj6XGxkaB+qjpZ1ifDr39UIkRO6v0tgY
         NqshcuylCfYExkLMT1wqjPItpX2r5Ai9ouk6Y=
In-Reply-To: <AANLkTimD74YP7GC1imbiRnKGETOfLYlGMkO682GqeU90-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?xYF1a2FzeiBXw7NqY2lja2k=?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(CCed to linux-nilfs)

jcicki wrote:
> Is it possible to disable checkpoints ?
>
> =C5=81ukasz W=C3=B3jcicki

No, checkpointing is essential for nilfs disk write.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
