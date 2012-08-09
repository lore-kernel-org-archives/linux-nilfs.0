From: Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Thu, 9 Aug 2012 12:33:09 +0200
Message-ID: <CANku=gha48jamDmmK6CxVEypryXPniPcgJ3BYa7zYm1EDyYGEg@mail.gmail.com>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com>
	<CANku=ghnDzkFHpPZ8eT9Y3kTM62zBKMk6TjBVraE4Kisa1TRPQ@mail.gmail.com>
	<F7DFCB7F-9015-4051-9A60-5056EAB81E4D@dubeyko.com>
	<CANku=ghdeeSLP6QsJh9jvs5fJwEYuTTV7w8iigE1nZoT74NYgQ@mail.gmail.com>
	<1344232478.1912.9.camel@slavad-ubuntu-11>
	<CANku=ggMp_gBgijee2umhNf5dBQO4zvmqopKBz70V1Z81oShVA@mail.gmail.com>
	<1344406417.1922.11.camel@slavad-ubuntu-11>
	<CANku=gjA=_Up4OJPLGU4P+8Zw3o8=J3BGFWTgPsHd9d=uUV_PA@mail.gmail.com>
	<3170A27E-46DD-4347-8F9B-FBF4BB4E0205@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=fwIIrR2jt5udSvnBCwcV5v+iZDLjMEqedqOP8IqjFzU=;
        b=Gmif44ABlASUGcUW0gZ+wwhUsZAdsZqIjhLpdLYjfgWwO2rMQvZew7DuQ0FDzOXuz3
         OMwbnPBihRRbjtYaL7pVE7pKB04xnd+vxwlAuhd+7wyAm5nIaEp9eV7ORKsuq5aBZ0rE
         0NILMYHYAlfhJXpsKbyZMopi67Mv09znxW9AXMnki/b3OBkw9/NUNT+iTYtCGXtTAUhu
         nVwKvq10N35xbGW8zz0C6j4YytHmsSywY8JlrAjWL55ZmVXDVbj6qC2eBEQKE2ihpilb
         KhX787E828Amx2pOE+v2DrW0kZ+qkRoocSY7froecd+9s7QjLVEQw0zCYWx2ACW/2Au4
         mCeg==
In-Reply-To: <3170A27E-46DD-4347-8F9B-FBF4BB4E0205-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

I'm having some issues at uploading the compressed image (it's "just"
2.3GB, but with my current connection it would take days, I'll upload
it on september).

Meanwhile nilfs_cleanerd managed to free some more space (over 1GB),
although nothing has changed since yesterday, thus everything seems
back to normality.
Thanks for the help and see you in september!


On Wed, Aug 8, 2012 at 7:54 PM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
> Hi Paolo,
>
> On Aug 8, 2012, at 7:03 PM, Paolo Giangrandi wrote:
>
>> If you are interested into it, I can share the 7.5GB raw filesystem image.
>>
>
> Yes, please share your file system image. It can be more efficient way to investigate the issue on the image.
>
> With the best regards,
> Vyacheslav Dubeyko.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
