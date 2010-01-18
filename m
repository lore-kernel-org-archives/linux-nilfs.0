From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Utilities & Usability
Date: Mon, 18 Jan 2010 14:18:00 +0900 (JST)
Message-ID: <20100118.141800.29272400.ryusuke@osrg.net>
References: <20D0961E8385B74FB47A1CBFE221DD99153728@exchg2.iservetech.local>
	<87bph2fid2.wl%jir@sekiba.com>
	<87aawdnqhd.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87aawdnqhd.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: johnm-ssvs9p6LcFAqDJ6do+/SaQ@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sun, 17 Jan 2010 16:24:30 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi, John
> 
> I realized that you might not in the linux-nilfs ML.
> Since nilfs-users are alread closed, I resent the mail 
> just in case your are not in the list.p

Thanks.  The old list was closed as Sekiba-san noted.
 
> At Sun, 10 Jan 2010 17:56:41 +0900,
> Jiro SEKIBA wrote:
> > 
> > Hi, John
> > 
> > If I understand what you wnat to do correctly,
> > you may be able to write a script using the lscp, mkcp and rmcp.
> > 
> > To create a snapshot, just invoke "mkcp -s" at an interval of "X"
> > minutes, as you mentioned.
> > 

Largly agreed.

We think snapshot management is a separate task for now, and are not
integrating it in cleanerd.

Although we can consider such integration, I think the current
functional decomposition is safer because the garbage collection is so
delicate; if we enbug cleanerd, it directly leads to a filesystem
corruption.

On the other hand, flexibility of checkpoints/snapshots management is
a reason of the userland cleaner implementation.  So, I don't deny the
proposal either.  Maybe, some sort of framework helping the snapshot
management should be provided after working out priority issues in
cleanerd which have been reported in this list.

> > To remove snapshot over the lifetime of "Y", parse the out put of lscp
> > and rmcp.  I don't think this is a big problem.

To be precise, rmcp doesn't work for snapshots.  'chcp cp' is used to
revert snapshots to checkpoints before their removal.

> > here are the simple bash script to display snapshot number
> > that is older than LIFETIME secs
> > 
> > --------------rmss.sh--------------
> > #!/bin/bash
> > 
> > LIFETIME=86400 # 60 * 60 * 24 sec, a day 
> > NOW=$(date +%s) #epoch time
> > TMP=/tmp/$$.ss
> > `lscp | grep ss |cut -b-41 > $TMP`

Snapshots can be listed with 'lscp -s'.  So, this can be simplified
to:

  `lscp -s |cut -b-41 > $TMP`

I feel this feature of lscp is much convenient though it's often
unnoticed.

> 
> > while read line;do
> >   ssno=$(echo  -n $line | cut -d' ' -f1)
> >   sstime=$(echo -n  $line | cut -d' ' -f2-)
> >   ssepoch=$(date -d"$sstime" +%s)
> >   t=$((ssepoch+$LIFETIME))
> > 
> >   if [ $NOW -gt $t ];then
> >     echo check point $ssno is older than $LIFETIME secs1
> >   fi
> > done <$TMP
> > 
> > rm -f $TMP
> > --------------rmss.sh--------------
> > 
> > I agree that higher level utility may help the daily works as you said,
> > however I'm not sure if it's the right way to integrate those tools low
> > level utils like nilfs-utils package.
> > 
> > Thanks
> > 
> > regards,
> > -- 
> > Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
