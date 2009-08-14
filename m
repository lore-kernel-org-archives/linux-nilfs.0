From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH:v2] nilfs2: tune write performance
Date: Fri, 14 Aug 2009 12:08:14 +0900 (JST)
Message-ID: <20090814.120814.33185837.ryusuke@osrg.net>
References: <1250155393-29046-1-git-send-email-jir@unicus.jp>
	<20090813.200606.92732522.ryusuke@osrg.net>
	<878whnf9as.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <878whnf9as.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Fri, 14 Aug 2009 10:55:55 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi, 
> 
> At Thu, 13 Aug 2009 20:06:06 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Thank you for your commitment!
> > 
> > The freeze time due to GC looks significantly shortened even though it
> > suffers some overhead on the average time.  Let's compare the absolute
> > values.  I'd like to apply this because the overhead looks enough
> > small, .. an order of sub-milliseconds.
> >
> > The patch looks good to me.
> > 
> > One thing what concerns me is the title.
> > 
> > May I change it to like "nilfs2: shorten freeze period due to GC in
> > write operation" ?
> >
> > We have to do "write performance tuning" much more ;)
> 
> That's right, the patch title is a bit too genercic.
> Please go ahead to change the title as above.

I've just rebased for-next branch and pushed this in it.

Thanks,
Ryusuke Konishi
