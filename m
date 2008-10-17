From: Daniel Phillips <phillips-sjnr1BIWhQJeoWH0uzbU5w@public.gmane.org>
Subject: Re: Ready for production ?
Date: Fri, 17 Oct 2008 04:15:30 -0700
Message-ID: <200810170415.30644.phillips@phunq.net>
References: <48F65636.5050405@prnet.org>
	<20081017.150912.86504903.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081017.150912.86504903.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Disposition: inline
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Cc: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Thursday 16 October 2008 23:09, Ryusuke Konishi wrote:
> Hi,
> 
> On Wed, 15 Oct 2008 22:44:38 +0200, David Arendt wrote:
> > Hi,
> > 
> > One thread with exactly this subject was started 12 months ago. So it
> > would be interested to make the point once again.
> > 
> > I am actually using nilfs2 on a volume where data integrity isn't
> > important and didn't have any problems until now.
> > 
> > So what would the developers say ? Is it ready for production ?
> 
> It's up to you. ;)
> 
> We aim to apply nilfs to commercial products, and we use it daily for
> laptops, desktop machines and a shared storage server (samba server).
> 
> However, we think still it needs further testing, debugging efforts,
> performance improvement, enhancement of administrative tools, and so
> forth.  At least for the stability, it was dramatically improved in
> the past year.

I don't think you should hold back from merging with mainline just
because of stability problems.  If you are mostly working except for
some small, hard to find problems, then get it merged, tell everybody
about the problems, and let people go hunt for them.  That is what
the open source process is about.

From what I can see, you are ready to go start the merging process
now.

Regards,

Daniel
