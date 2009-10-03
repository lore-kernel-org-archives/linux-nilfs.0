From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: NILFS errors.
Date: Sat, 3 Oct 2009 13:48:52 +0200
Message-ID: <200910031348.52742.yuri@itinteg.net>
References: <200910021857.28569.yuri@itinteg.net>
	<200910031221.34016.yuri@itinteg.net>
	<20091003.201330.10734740.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091003.201330.10734740.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Saturday 03 October 2009 13:13:30 Ryusuke Konishi wrote:
> On Sat, 3 Oct 2009 12:21:33 +0200, Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org> wrote:
> > Thank you for patch. I have install it just now and reformat /dev/md4.
> > Is it planned some fsck tool?
> 
> Unfortunately No (at least for the time being).
> 
> > I can help with tests if necessary.
> > Yuri.
> 
> Yes, I would appreciate if you could help testing.
> 
> Before that, please let me know whether the corruption is reproducible
> on a new file system after applying the "fix missing zero-fill
> initialization of btree node cache" patch.
> 
> It is necessary to narrow down the cause of your problem.
> 
> Thank you,
> Ryusuke Konishi
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
> 
All work well, right for now. I will send mail to list if some errors appear.

Yuri.
