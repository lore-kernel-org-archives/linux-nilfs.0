From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Thu, 10 Sep 2009 21:26:19 +0200
Message-ID: <20090910192619.GA1263@heethoofdje.13thmonkey.org>
References: <2324ff2b0909101216q31dad1a8y43ea0f229923a0c3@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2324ff2b0909101216q31dad1a8y43ea0f229923a0c3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hi Prasenjit Giri,

On Fri, Sep 11, 2009 at 12:46:04AM +0530, Prasenjit Giri wrote:
> Even after looking through various sites, forums, mailing lists I could not
> uncover the present directoy management of NILFS2.
> 
> As I see a B-tree directory management in your long term to do list, it
> would be really nice if someone would ought to share the information
> regarding the present directory management of NILFS2

Currently directories are recorded just as a sequential file but not filled
with user data but with dirent entries in their blocks like ext2fs does.
Nothing special about that :)

I dont know if b+tree directory management would be preferable though. With
some smart caching all directory operations can be made O(1) anyway.

With regards,
Reinoud Zandijk
