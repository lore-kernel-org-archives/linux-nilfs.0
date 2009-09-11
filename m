From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Fri, 11 Sep 2009 10:21:18 +0900 (JST)
Message-ID: <20090911.102118.69189169.ryusuke@osrg.net>
References: <2324ff2b0909101216q31dad1a8y43ea0f229923a0c3@mail.gmail.com>
	<20090910192619.GA1263@heethoofdje.13thmonkey.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090910192619.GA1263-bVHBekiX4bNgoMqBc1r0ESegHCQxtGRMHZ5vskTnxNA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org, Prasenjit Giri <tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Prasenjit Giri, and Reinoud,
On Thu, 10 Sep 2009 21:26:19 +0200, Reinoud Zandijk <wrote:
> Hi Prasenjit Giri,
> 
> On Fri, Sep 11, 2009 at 12:46:04AM +0530, Prasenjit Giri wrote:
> > Even after looking through various sites, forums, mailing lists I could not
> > uncover the present directoy management of NILFS2.
> > 
> > As I see a B-tree directory management in your long term to do list, it
> > would be really nice if someone would ought to share the information
> > regarding the present directory management of NILFS2
> 
> Currently directories are recorded just as a sequential file but not filled
> with user data but with dirent entries in their blocks like ext2fs does.
> Nothing special about that :)
>
> I dont know if b+tree directory management would be preferable though. With
> some smart caching all directory operations can be made O(1) anyway.
> 
> With regards,
> Reinoud Zandijk

Yes, directory is a file and it's already managed with b-tree like
other files.  However, the current directory design is not O(log n),
and is actually slow especially for file creation.

So, it leaves room for considering the true "b-tree directory
management".

OTOH, the replacement has the following points to notice:

 1) It may complicate the log writer.

    The current log writer is designed on the basis that every data
    and meta data is a file.  In NILFS, inodes, segment usage state,
    and checkpoints, are managed with correponding meta-data files.

    The true "b-tree directory management" may break this uniformity.

 2) A disk format change is required.
    (We can deem this a trade-off at this stage)

This may be a -v3 material.  But anyway, patch proposals are welcome.

Thank you,
Ryusuke Konishi
