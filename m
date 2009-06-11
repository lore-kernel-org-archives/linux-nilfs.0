From: Dave <dave-/hCUnnzDXf0AvxtiuMwx3w@public.gmane.org>
Subject: Re: Stressing GC
Date: Thu, 11 Jun 2009 08:17:51 +0400
Message-ID: <4A30856F.3000103@0bits.com>
References: <20090610210859.GA17619@apu.cs.fiu.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090610210859.GA17619-F34IG+UkkWQ4ZZIPogyGsg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>, luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org

On 06/11/09 01:08, Luis Useche wrote:
> Hi Guys,
> 
> I was doing some experiments on nilfs2 to stress the garbage collection
> with different file system usage. Unfortunately, it was unable to pass the
> first test since nilfs reports no space available eventhough there are no
> files in the file system! I guess the GC is not collecting space fast
> enough and the file system ends up with no space available.
> 
> Do you have any workaround to this problem?

I don't understand. There is no 'problem' to workaround. This is by 
design. You're right, the GC has to reclaim your deleted files before it 
release the space to the filesystem. If you remove all your checkpoints 
and wait for your 'protection_period' interval you should see you space 
reappear. The whole idea or nilfs is that you could do a 'rm -rf *' and 
be left with no files, but still recover all your files from a 
checkpoint that happened for you automatically a few seconds ago.

D
