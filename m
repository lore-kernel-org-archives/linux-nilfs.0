From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: Work around uncleanable full filesystem
Date: Fri, 18 Jan 2013 10:17:19 +0400
Message-ID: <1358489839.2101.13.camel@slavad-ubuntu>
References: <1358178899-26347-1-git-send-email-sven@narfation.org>
	 <1358258241.2094.9.camel@slavad-ubuntu> <2312125.8JVqXAGppa@bentobox>
	 <1358409438.2513.14.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=Y4fLHs9odf5q0FmYggi775AswnEEzl0CGNRMhUt40sw=;
	b=jcxfPa5qisKUu1mP/xCtsOoqIO1GWGnT1BxKmXxkhffgGSd2PIWzYkAGn5JmWPGm3T+n14DCJPm57HT6t7WO21hn6eK6WTzE/YZN6pEzP5INm2tcjoVP+ZdzUxVZTrgU;
In-Reply-To: <1358409438.2513.14.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sven Eckelmann <sven-KaDOiPu9UxWEi8DpZVb4nw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 2013-01-17 at 11:57 +0400, Vyacheslav Dubeyko wrote:
> On Tue, 2013-01-15 at 16:17 +0100, Sven Eckelmann wrote:
> > On Tuesday 15 January 2013 17:57:21 Vyacheslav Dubeyko wrote:
> > > Could you share more details about your environment? What version of
> > > nilfs-utils do you use?
> > > 
> > > Maybe do you have some NILFS2-related error messages in your system log?
> > > 
> > > Or, maybe, reproducing path is more complex as you described?
> > 
> > System running Debian Wheezy (amd64) with linux 3.2.35-2 and nilfs-tools 
> > 2.1.4-1. The nilfs partition is a secondary partition on a CFCard and is not 
> > used in normal situations. There are different processes running in the 
> > background... for example ntpd. There are no interesting infos in the system 
> > log (unless you are interested in nilfs_cleanerd output saying nothing else 
> > than "pause"/"sleep"/"0 segments selected to be cleaned"/...).
> > 
> > Following way is a good way to force a similar problem (this is not the way I 
> > produced it the first time, but it is a possible scenario):
> > 
> > $ cd /nilfs/
> > $ ntpdate-debian
> > $ date -s @`date +'%s'|awk '{ print $1+9000}'`
> > $ for i in `seq 0 300`; do dd if=/dev/zero of=foo$i count=22528; done
> > $ sleep 360
> > $ ntpdate-debian
> > $ touch asd
> > $ rm *
> > $ date -s @`date +'%s'|awk '{ print $1+10000}'`
> > $ mount -o remount /nilfs/
> > 
> > It is a little bit harsh, but a similar thing can easily happen in real world 
> > with non-monotonic clocks (but the jumps are usually a little smaller).
> > 
> 
> Yes, I can reproduce the issue. But I think that it doesn't make sense
> to change something in timestamp policy of GC. Unfortunately, we have
> currently only timestamp policy. And I think that it needs to use
> another GC policy in the case of such issue. So, the proper fix will be
> adding another GC policy.
> 
> Anyway, I think that possible time deviation can achieve about minutes
> in real life. And probability to encounter such issue in real life very
> low. I think so because it is hardly to encounter in real life of
> coincidence such factors as (1) to fill a whole volume and then to
> remove all files during several minutes and (2) immediately update
> system time.
> 
> If you do so by the hands then, from my point of view, you know what you
> are doing.
> 
> As a resume, I think that proper fix of such issue can be adding of
> additional GC policies that is not affected by such use-case.
> 

After additional thinking about the issue, I am thinking about
nilfs-clean utility modification. I mean that it needs to have
opportunity to define time point of the last write time (ss_nongc_ctime)
by hands in the case of the issue occurrence. So, an user should have
opportunity to detect situation when volume hasn't free segments because
of GC idleness and to correct GC's behaviour by hands (likewise starting
GC by "nilfs-clean -p 0").

With the best regards,
Vyacheslav Dubeyko.

> Thanks,
> Vyacheslav Dubeyko.
> 
> > Kind regards,
> > 	Sven
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
