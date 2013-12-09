From: Jon Watte <jwatte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs error
Date: Mon, 9 Dec 2013 08:33:58 -0800
Message-ID: <CAJgyHGMmxs8RUiFiZyJW2xNODuip_1yYkUTZ1_-VSPWivtHeSg@mail.gmail.com>
References: <CAJgyHGOeRhj7D4GeyfHhBjXLE3K40DiakT2Zms2D7TPB-BiRog@mail.gmail.com>
	<BA9C3894-7D2F-4FA1-88DE-E830102A0B5D@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=rRH3Lf76zhOs04KP4tVP9TjBwUM8SV7PthQL8bAoo0Q=;
        b=e2BdA9h2XCxx76iw7tPRnQ0o04lLay7mV4Tn61igN6bl3eYJlskBWUYXLq893apf74
         L6/Q0D5sxcWbDlPbRnD+pvDG58GKrG8AkatqgSgLE7fVM3O5MpSsE3b3K0MIKhorPLIG
         2pTjN/Qc3uAeywk4cT7/F7+zp9/0R6I+ecwGbCShhHadh8y3MzkFQYAZlGUNLYdXflvI
         VkCtkahNLCfPVlIeVc0OzvNoUYyxD4D8XFIUmsyLb3Lh0fDzJ97b/UFv4ODqds58UF17
         ilcTzCtfTo7cTA3krI+DBz/zCTzL1Jh1Vryxl8Pn6Wo6H13y5CBY2mNR9grkpuQRQEwr
         WE4A==
In-Reply-To: <BA9C3894-7D2F-4FA1-88DE-E830102A0B5D-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I am using Linux robot1 3.12.3-1-ARCH #1 SMP PREEMPT Wed Dec 4
21:45:42 CET 2013 x86_64 GNU/Linux

Is that an "old" kernel?

Also, note that an "old" kernel (from February this year) could mount
this image, whereas this newer kernel hung. Is that consistent with
the changes you have done?

Sincerely,

jw




Sincerely,

Jon Watte


--
"I pledge allegiance to the flag of the United States of America, and
to the republic for which it stands, one nation indivisible, with
liberty and justice for all."
~ Adopted by U.S. Congress, June 22, 1942


On Sat, Dec 7, 2013 at 2:34 AM, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org> wrote:
>
> On Dec 7, 2013, at 5:17 AM, Jon Watte wrote:
>
> [snip]
>> However, yesterday when booting up agian, it refused to mount the root
>> disk, and booting was halted, with the messages shown in the below
>> photograph. Note that, because I can't boot, I can't get this output
>> in a copy-and-paste-able form!
>>
>> https://pbs.twimg.com/media/BaxOmptCYAABQuW.jpg:large
>>
>> The two repeated messages are (typed in from the photo):
>> NILFS: bad bree node (blocknr=1364234) ; level = 100; flags = 0x73;
>> nchildren = 12336
>> NILFS error (device sda1): nilfs_bmap_lookup_contig: broken bmap
>> (inode number=3935)
>
> What linux kernel version do you have?
>
> I had fixed the reason of such problem by patch [1]. So, please check and
> share your kernel version, firstly. I suppose that you are simply using old
> kernel version.
>
> With the best regards,
> Vyacheslav Dubeyko.
>
> [1] http://comments.gmane.org/gmane.comp.file-systems.nilfs.user/3082
>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
