From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: df seems to show wrong disk usage
Date: Sun, 21 Jun 2009 18:18:03 +0900 (JST)
Message-ID: <20090621.181803.122351359.ryusuke@osrg.net>
References: <20090620200832.GD23838@lh.kyla.fi>
	<20090620223607.GE23838@lh.kyla.fi>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090620223607.GE23838-7bsdmvTMBDzHOG6cAo2yLw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sliedes-kf+aQKke1yb1KXRcyAk9cg@public.gmane.org

Hi!
On Sun, 21 Jun 2009 01:36:08 +0300, Sami Liedes wrote:
> On Sat, Jun 20, 2009 at 11:08:33PM +0300, Sami Liedes wrote:
> > I've been copying data to a 700 GiB nilfs2 volume from a fast disk for
> > 2.5 hours now. df -h shows there's only 37 GiB of data there:
> > 
> > /dev/mapper/lacie     699G   37G  628G   6% /media/lacie
> > 
> > Yet running du -csh in one big directory in /media/lacie at the same
> > time shows disk usage to be 62G in that directory alone.
> 
> Looking at the data, it contains a lot of hard links, so this may be
> something to do with them.
> 
> 	Sami

For nilfs, `df -h' shows the real disk usage which includes past data
as well as metadata.  OTOH, `du -h' does not count neither.

Usually, df -h shows larger values than du -h if hardlinks are taken
into account (this is default behavior).

So, something looks strange in your case.


Could you try lssu commands?

It displays disk usage state of nilfs.

`lssu -a' shows all segments in the nilfs partition.

$ expr \( `lssu | wc -l` - 1 \) \* 8

shows disk usage in Mega bytes unit.

If this value differs from the value of 'df -h', the on-disk value of
in-use segments likely went wrong.


Thanks,
Ryusuke Konishi
